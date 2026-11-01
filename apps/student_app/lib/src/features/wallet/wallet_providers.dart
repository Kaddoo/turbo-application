import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';

import '../../core/providers.dart';
import '../home/service_area.dart';

/// The first page of transactions, for the wallet screen.
final recentTransactionsProvider =
    FutureProvider.autoDispose<List<WalletTransaction>>((ref) async {
      final response = await ref
          .read(clientProvider)
          .api
          .getWalletApi()
          .listWalletTransactions(limit: 5);
      return response.data!.data.toList();
    });

class TransactionsState {
  const TransactionsState({
    this.items = const [],
    this.cursor,
    this.hasMore = false,
    this.loadingMore = false,
    this.error,
  });

  final List<WalletTransaction> items;
  final String? cursor;
  final bool hasMore;
  final bool loadingMore;
  final ApiProblem? error;
}

class TransactionsController extends AsyncNotifier<TransactionsState> {
  TransactionType? filter;

  @override
  Future<TransactionsState> build() => _page(null);

  Future<TransactionsState> _page(
    String? cursor, {
    List<WalletTransaction> before = const [],
  }) async {
    try {
      final response = await ref
          .read(clientProvider)
          .api
          .getWalletApi()
          .listWalletTransactions(type: filter, cursor: cursor, limit: 20);
      final page = response.data!;
      return TransactionsState(
        items: [...before, ...page.data],
        cursor: page.page.nextCursor,
        hasMore: page.page.hasMore,
      );
    } catch (e) {
      throw problemOf(e);
    }
  }

  Future<void> setFilter(TransactionType? type) async {
    filter = type;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _page(null));
  }

  Future<void> more() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(
      TransactionsState(
        items: current.items,
        cursor: current.cursor,
        hasMore: true,
        loadingMore: true,
      ),
    );
    try {
      state = AsyncData(await _page(current.cursor, before: current.items));
    } catch (e) {
      state = AsyncData(
        TransactionsState(
          items: current.items,
          cursor: current.cursor,
          hasMore: true,
          error: problemOf(e),
        ),
      );
    }
  }
}

final transactionsProvider =
    AsyncNotifierProvider.autoDispose<
      TransactionsController,
      TransactionsState
    >(TransactionsController.new);

/// Where a top-up stands while the student approves it on their phone.
class TopupFlowState {
  const TopupFlowState({
    required this.topup,
    required this.startedAt,
    this.timedOut = false,
    this.checking = false,
  });

  final Topup topup;
  final DateTime startedAt;
  final bool timedOut;
  final bool checking;

  bool get finished => topup.status != TopupStatusEnum.pending;

  TopupFlowState copyWith({Topup? topup, bool? timedOut, bool? checking}) =>
      TopupFlowState(
        topup: topup ?? this.topup,
        startedAt: startedAt,
        timedOut: timedOut ?? this.timedOut,
        checking: checking ?? this.checking,
      );
}

/// Creates a top-up and watches it. One idempotency key per intention: the same
/// amount retried reuses the key, so a dropped connection can never charge
/// twice; a different amount, or a finished top-up, starts a new intention.
class TopupController extends Notifier<TopupFlowState?> {
  static const watchFor = Duration(seconds: 120);
  static const every = Duration(seconds: 3);

  IdempotencyKey? _key;
  int? _keyAmount;
  Timer? _timer;

  @override
  TopupFlowState? build() {
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  /// A top-up that has not finished, even if we stopped watching it: the
  /// student may still approve it, so starting another could charge twice.
  bool get hasPending => state != null && !state!.finished;

  /// Starts a top-up. Throws [ApiProblem].
  Future<void> start(int amountPesewas) async {
    if (_key == null || _keyAmount != amountPesewas) {
      _key = IdempotencyKey();
      _keyAmount = amountPesewas;
    }
    try {
      final response = await ref
          .read(clientProvider)
          .api
          .getWalletApi()
          .createTopup(
            idempotencyKey: _key!.value,
            topupCreate: TopupCreate(
              amountPesewas: amountPesewas,
              channel: TopupCreateChannelEnum.mobileMoney,
            ),
          );
      state = TopupFlowState(topup: response.data!, startedAt: clock.now());
      _watch();
    } catch (e) {
      throw problemOf(e);
    }
  }

  void _watch() {
    _timer?.cancel();
    if (state == null || state!.finished) {
      _settle();
      return;
    }
    _timer = Timer.periodic(every, (_) => check());
  }

  /// Asks the server now. Safe to call from a button or on app resume.
  Future<void> check() async {
    final current = state;
    if (current == null) return;
    state = current.copyWith(checking: true);
    try {
      final response = await ref
          .read(clientProvider)
          .api
          .getWalletApi()
          .getTopup(id: current.topup.id);
      state = state?.copyWith(topup: response.data!, checking: false);
    } catch (_) {
      // A missed poll is not a failure; the next one will answer.
      state = state?.copyWith(checking: false);
    }
    final now = state;
    if (now == null) return;
    if (now.finished) {
      _timer?.cancel();
      _settle();
    } else if (clock.now().difference(now.startedAt) > watchFor) {
      _timer?.cancel();
      state = now.copyWith(timedOut: true);
    }
  }

  void _settle() {
    _key = null;
    _keyAmount = null;
    ref.invalidate(walletProvider);
    ref.invalidate(recentTransactionsProvider);
  }

  /// Back to nothing in progress.
  void clear() {
    _timer?.cancel();
    state = null;
  }
}

final topupProvider = NotifierProvider<TopupController, TopupFlowState?>(
  TopupController.new,
);

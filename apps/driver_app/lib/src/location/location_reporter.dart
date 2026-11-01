import 'dart:async';

import 'package:flutter/foundation.dart';

import 'location_buffer.dart';
import 'tracked_point.dart';

typedef SendPoints = Future<void> Function(List<TrackedPoint> points);

@immutable
class ReporterState {
  const ReporterState({
    this.running = false,
    this.startedAt,
    this.fixesReceived = 0,
    this.pointsSent = 0,
    this.requestsSent = 0,
    this.pointsDropped = 0,
    this.buffered = 0,
    this.failures = 0,
    this.lastFixAt,
    this.lastSuccessAt,
    this.lastError,
  });

  final bool running;
  final DateTime? startedAt;
  final int fixesReceived;
  final int pointsSent;
  final int requestsSent;
  final int pointsDropped;
  final int buffered;
  final int failures;
  final DateTime? lastFixAt;
  final DateTime? lastSuccessAt;
  final String? lastError;

  ReporterState copyWith({
    bool? running,
    DateTime? startedAt,
    int? fixesReceived,
    int? pointsSent,
    int? requestsSent,
    int? pointsDropped,
    int? buffered,
    int? failures,
    DateTime? lastFixAt,
    DateTime? lastSuccessAt,
    String? lastError,
    bool clearError = false,
  }) =>
      ReporterState(
        running: running ?? this.running,
        startedAt: startedAt ?? this.startedAt,
        fixesReceived: fixesReceived ?? this.fixesReceived,
        pointsSent: pointsSent ?? this.pointsSent,
        requestsSent: requestsSent ?? this.requestsSent,
        pointsDropped: pointsDropped ?? this.pointsDropped,
        buffered: buffered ?? this.buffered,
        failures: failures ?? this.failures,
        lastFixAt: lastFixAt ?? this.lastFixAt,
        lastSuccessAt: lastSuccessAt ?? this.lastSuccessAt,
        lastError: clearError ? null : (lastError ?? this.lastError),
      );

  /// The phone has stopped producing positions (OS paused the service, GPS off).
  bool gpsSilent(DateTime now, Duration after) {
    if (!running) return false;
    final since = lastFixAt ?? startedAt;
    return since != null && now.difference(since) > after;
  }

  /// Positions are arriving but the server has not accepted any recently.
  bool serverUnreachable(DateTime now, Duration after) {
    if (!running) return false;
    final since = lastSuccessAt ?? startedAt;
    return since != null && now.difference(since) > after;
  }
}

/// Turns a stream of GPS fixes into API calls: one point per [interval], sent
/// as soon as it is taken, buffered when the call fails, retried on the next
/// tick, and capped at 20 points per request.
class LocationReporter {
  LocationReporter({
    required this.source,
    required this.send,
    this.interval = const Duration(seconds: 5),
    LocationBuffer? buffer,
    DateTime Function()? now,
  })  : _now = now ?? DateTime.now,
        _buffer = buffer ?? LocationBuffer(now: now);

  final Stream<TrackedPoint> source;
  final SendPoints send;
  final Duration interval;
  final DateTime Function() _now;
  final LocationBuffer _buffer;

  final ValueNotifier<ReporterState> state = ValueNotifier(const ReporterState());

  StreamSubscription<TrackedPoint>? _sub;
  Timer? _retry;
  DateTime? _lastAccepted;
  bool _flushing = false;
  bool _flushAgain = false;

  void start() {
    if (state.value.running) return;
    state.value = ReporterState(running: true, startedAt: _now());
    _lastAccepted = null;
    _sub = source.listen(_onFix, onError: (Object e) {
      state.value = state.value.copyWith(lastError: 'gps: $e');
    });
    // Covers the case where fixes stop but a backlog still needs sending.
    _retry = Timer.periodic(interval, (_) => _flush());
  }

  Future<void> stop() async {
    _retry?.cancel();
    _retry = null;
    state.value = state.value.copyWith(running: false);
    final sub = _sub;
    _sub = null;
    await sub?.cancel();
  }

  void dispose() {
    _sub?.cancel();
    _retry?.cancel();
    state.dispose();
  }

  void _onFix(TrackedPoint p) {
    state.value = state.value.copyWith(
      fixesReceived: state.value.fixesReceived + 1,
      lastFixAt: _now(),
    );
    final last = _lastAccepted;
    if (last != null && p.recordedAt.difference(last) < interval) return;
    _lastAccepted = p.recordedAt;
    _buffer.add(p);
    _flush();
  }

  Future<void> _flush() async {
    if (_flushing) {
      _flushAgain = true;
      return;
    }
    _flushing = true;
    try {
      do {
        _flushAgain = false;
        final dropped = _buffer.dropStale();
        if (dropped > 0) {
          state.value = state.value.copyWith(pointsDropped: state.value.pointsDropped + dropped);
        }
        while (!_buffer.isEmpty) {
          final batch = _buffer.peekBatch();
          try {
            await send(batch);
          } catch (e) {
            state.value = state.value.copyWith(
              failures: state.value.failures + 1,
              lastError: e is Exception || e is Error ? _describe(e) : '$e',
              buffered: _buffer.length,
            );
            return;
          }
          _buffer.removeFirst(batch.length);
          state.value = state.value.copyWith(
            pointsSent: state.value.pointsSent + batch.length,
            requestsSent: state.value.requestsSent + 1,
            lastSuccessAt: _now(),
            clearError: true,
          );
        }
        state.value = state.value.copyWith(buffered: _buffer.length);
      } while (_flushAgain);
    } finally {
      _flushing = false;
    }
  }

  // Error text only: never include request bodies or headers (tokens).
  String _describe(Object e) => e.runtimeType.toString();
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../l10n/app_localizations.dart';
import 'geo.dart';
import 'place_search.dart';
import 'service_area.dart';
import 'trip_draft.dart';

/// Choose the pickup point and the drop-off, then go on to the price.
class DestinationScreen extends ConsumerStatefulWidget {
  const DestinationScreen({super.key});

  @override
  ConsumerState<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends ConsumerState<DestinationScreen> {
  final _query = TextEditingController();
  Timer? _debounce;
  List<PlaceSuggestion> _results = const [];
  bool _searching = false;
  String? _searchError;
  bool _pickingPickup = false;
  bool _showNeedPickup = false;

  @override
  void initState() {
    super.initState();
    ref.read(placeSearchProvider).newSession();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _onChanged(String value, GeoJsonPolygon? boundary) {
    _debounce?.cancel();
    final q = value.trim();
    if (q.length < 3) {
      setState(() {
        _results = const [];
        _searching = false;
        _searchError = null;
      });
      return;
    }
    setState(() => _searching = true);
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        final found = await ref
            .read(placeSearchProvider)
            .search(q, bounds: searchBounds(boundary));
        if (mounted && _query.text.trim() == q) {
          setState(() {
            _results = found;
            _searching = false;
            _searchError = null;
          });
        }
      } catch (_) {
        if (mounted) {
          setState(() {
            _searching = false;
            _searchError = AppLocalizations.of(context).destSearchFailed;
          });
        }
      }
    });
  }

  Future<void> _choose(PlaceSuggestion s) async {
    try {
      final place = await ref.read(placeSearchProvider).resolve(s);
      ref.read(tripDraftProvider.notifier).setDropoff(place);
      setState(() => _results = const []);
    } catch (_) {
      if (mounted) {
        setState(
          () => _searchError = AppLocalizations.of(context).destSearchFailed,
        );
      }
    }
  }

  void _continue() {
    final draft = ref.read(tripDraftProvider);
    if (draft.pickup == null) {
      setState(() => _showNeedPickup = true);
      return;
    }
    if (draft.dropoff == null) return;
    context.go('/home/quote');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final draft = ref.watch(tripDraftProvider);
    final area = ref.watch(serviceAreaProvider).value?.area;
    final search = ref.watch(placeSearchProvider);
    final saved = ref.watch(savedPlacesProvider);
    final points = (area?.pickupPoints ?? const <PickupPoint>[])
        .where((p) => p.isActive)
        .toList();

    final dropoffPoints = points
        .where((p) => p.id != draft.pickup?.pickupPointId)
        .toList();

    Widget pickupCard() {
      final pickup = draft.pickup;
      return TurboCard(
        onTap: points.isEmpty
            ? null
            : () => setState(() => _pickingPickup = !_pickingPickup),
        semanticLabel: l10n.destPickupLabel,
        child: Row(
          children: [
            Icon(Icons.trip_origin, color: t.colors.accentText),
            const SizedBox(width: TurboSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.destPickupLabel, style: text.bodySmall),
                  Text(
                    pickup == null
                        ? l10n.destPickupChoose
                        : (pickup.label ?? l10n.destPickupNone),
                    style: text.bodyLarge,
                  ),
                  if (pickup?.landmark != null)
                    Text(pickup!.landmark!, style: text.bodySmall),
                ],
              ),
            ),
            if (points.isNotEmpty)
              Icon(_pickingPickup ? Icons.expand_less : Icons.expand_more),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                TurboSpacing.screen,
                TurboSpacing.md,
                TurboSpacing.screen,
                0,
              ),
              child: Row(
                children: [
                  TurboIconButton(
                    icon: Icons.arrow_back,
                    label: l10n.back,
                    onPressed: () => context.go('/home'),
                  ),
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        l10n.destTitle,
                        textAlign: TextAlign.center,
                        style: text.titleMedium,
                      ),
                    ),
                  ),
                  const SizedBox.square(dimension: TurboSizes.iconButton),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(TurboSpacing.screen),
                children: [
                  pickupCard(),
                  if (_showNeedPickup && draft.pickup == null)
                    Padding(
                      padding: const EdgeInsets.only(top: TurboSpacing.sm),
                      child: Text(
                        l10n.destNeedPickup,
                        style: text.bodyMedium?.copyWith(
                          color: t.colors.danger,
                        ),
                      ),
                    ),
                  if (_pickingPickup)
                    for (final p in points)
                      TurboListRow(
                        card: true,
                        title: p.name,
                        leading: const Icon(Icons.place_outlined),
                        onTap: () {
                          ref
                              .read(tripDraftProvider.notifier)
                              .setPickup(locationOfPickup(p));
                          setState(() => _pickingPickup = false);
                        },
                      ),
                  const SizedBox(height: TurboSpacing.lg),
                  if (draft.dropoff != null)
                    TurboCard(
                      child: Row(
                        children: [
                          Icon(Icons.flag_outlined, color: t.colors.accentText),
                          const SizedBox(width: TurboSpacing.md),
                          Expanded(
                            child: Text(
                              draft.dropoff!.label ?? '',
                              style: text.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (search.available)
                    TurboTextField(
                      label: l10n.destSearchLabel,
                      controller: _query,
                      textInputAction: TextInputAction.search,
                      onChanged: (v) => _onChanged(v, area?.boundary),
                    ),
                  if (_searching)
                    const Padding(
                      padding: EdgeInsets.only(top: TurboSpacing.md),
                      child: LoadingState(rows: 1),
                    ),
                  if (_searchError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: TurboSpacing.md),
                      child: Text(
                        _searchError!,
                        style: text.bodyMedium?.copyWith(
                          color: t.colors.danger,
                        ),
                      ),
                    ),
                  if (!_searching &&
                      _results.isEmpty &&
                      _query.text.trim().length >= 3 &&
                      _searchError == null &&
                      draft.dropoff == null)
                    Padding(
                      padding: const EdgeInsets.only(top: TurboSpacing.md),
                      child: Column(
                        children: [
                          const HeroIcon(icon: Icons.wrong_location_outlined),
                          const SizedBox(height: TurboSpacing.md),
                          Text(
                            l10n.destSearchNoResults,
                            style: text.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  for (final r in _results)
                    TurboListRow(
                      card: true,
                      title: r.title,
                      subtitle: r.subtitle,
                      leading: const Icon(Icons.place_outlined),
                      onTap: () => _choose(r),
                    ),
                  const SizedBox(height: TurboSpacing.xl),
                  // Official points double as drop-offs, so there is always
                  // somewhere to go even when place search is not set up.
                  Semantics(
                    header: true,
                    child: Text(l10n.destPlacesTitle, style: text.titleSmall),
                  ),
                  const SizedBox(height: TurboSpacing.sm),
                  if (dropoffPoints.isEmpty)
                    Text(l10n.destPlacesEmpty, style: text.bodyMedium)
                  else
                    for (final p in dropoffPoints)
                      TurboListRow(
                        card: true,
                        title: p.name,
                        leading: const Icon(Icons.place_outlined),
                        onTap: () => ref
                            .read(tripDraftProvider.notifier)
                            .setDropoff(locationOfPickup(p)),
                      ),
                  const SizedBox(height: TurboSpacing.xl),
                  Semantics(
                    header: true,
                    child: Text(l10n.destSavedTitle, style: text.titleSmall),
                  ),
                  const SizedBox(height: TurboSpacing.sm),
                  saved.when(
                    loading: () => const LoadingState(rows: 1),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (places) => places.isEmpty
                        ? Text(l10n.destSavedEmpty, style: text.bodyMedium)
                        : Column(
                            children: [
                              for (final p in places)
                                TurboListRow(
                                  card: true,
                                  title: p.label,
                                  subtitle: p.location.label,
                                  leading: const Icon(Icons.bookmark_border),
                                  onTap: () => ref
                                      .read(tripDraftProvider.notifier)
                                      .setDropoff(p.location),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TurboSpacing.screen),
              child: TurboButton(
                label: l10n.destContinue,
                onPressed: draft.dropoff == null ? null : _continue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

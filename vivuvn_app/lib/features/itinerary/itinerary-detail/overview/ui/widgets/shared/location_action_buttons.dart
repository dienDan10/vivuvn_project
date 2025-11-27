import 'package:flutter/material.dart';

import '../../../../schedule/ui/widgets/place_action_button_direction.dart';
import '../../../../schedule/ui/widgets/place_action_button_location.dart';

class LocationActionButtons extends StatelessWidget {
  const LocationActionButtons({
    super.key,
    this.placeUri,
    this.directionsUri,
    this.fallbackQuery,
  });

  final String? placeUri;
  final String? directionsUri;
  final String? fallbackQuery;

  String? get _locationUrl =>
      _normalize(placeUri) ?? _buildSearchUrl(fallbackQuery);
  String? get _directionsUrl =>
      _normalize(directionsUri) ?? _buildDirectionsUrl(fallbackQuery);

  bool get _hasAny => _locationUrl != null || _directionsUrl != null;

  @override
  Widget build(final BuildContext context) {
    if (!_hasAny) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          if (_directionsUrl != null)
            PlaceActionButtonDirection(
              url: _directionsUrl!,
              compact: true,
            ),
          if (_directionsUrl != null && _locationUrl != null)
            const SizedBox(width: 8),
          if (_locationUrl != null)
            PlaceActionButtonLocation(
              url: _locationUrl!,
              compact: true,
            ),
        ],
      ),
    );
  }

  String? _buildSearchUrl(final String? query) {
    final normalized = _normalize(query);
    if (normalized == null) return null;
    final encoded = Uri.encodeComponent(normalized);
    return 'https://www.google.com/maps/search/?api=1&query=$encoded';
  }

  String? _buildDirectionsUrl(final String? query) {
    final normalized = _normalize(query);
    if (normalized == null) return null;
    final encoded = Uri.encodeComponent(normalized);
    return 'https://www.google.com/maps/dir/?api=1&destination=$encoded';
  }

  String? _normalize(final String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}


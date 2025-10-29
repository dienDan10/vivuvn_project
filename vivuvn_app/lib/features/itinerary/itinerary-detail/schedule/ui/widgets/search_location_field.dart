import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../overview/controller/favourite_places_controller.dart';
import '../../../overview/controller/search_location_controller.dart';
import '../../../overview/modal/location.dart';
import 'favorite_places_list.dart';
import 'search_input.dart';
import 'search_results_list.dart';

class SearchLocationField extends ConsumerStatefulWidget {
  const SearchLocationField({
    super.key,
    required this.hintText,
    this.onSelected,
  });

  final String hintText;
  final ValueChanged<Location>? onSelected;

  @override
  ConsumerState<SearchLocationField> createState() =>
      _SearchLocationFieldState();
}

class _SearchLocationFieldState extends ConsumerState<SearchLocationField> {
  final TextEditingController _controller = TextEditingController();
  List<Location> _results = [];
  bool _isLoading = false;
  Object? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(final String query) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await ref
          .read(searchLocationControllerProvider.notifier)
          .searchLocation(query);
      setState(() => _results = results);
    } catch (e) {
      setState(() => _error = e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final favState = ref.watch(favouritePlacesControllerProvider);
    final favPlaces = favState.places;
    final text = _controller.text.trim();
    final showFavorites = text.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchInputField(
          controller: _controller,
          hintText: widget.hintText,
          onQueryChanged: _search,
        ),
        const SizedBox(height: 16),

        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Lỗi: $_error',
              style: const TextStyle(color: Colors.red),
            ),
          )
        else if (showFavorites)
          Expanded(
            child: FavoritePlacesList(
              favPlaces: favPlaces,
              onSelected: widget.onSelected,
            ),
          )
        else if (_results.isEmpty)
          const Expanded(
            child: Center(child: Text('Không tìm thấy địa điểm nào.')),
          )
        else
          Expanded(
            child: SearchResultsList(
              results: _results,
              favPlaces: favPlaces,
              onSelected: widget.onSelected,
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../overview/controller/search_location_controller.dart';
import '../../../overview/modal/location.dart';
import '../../../overview/ui/widgets/empty_search_result.dart';
import '../../../overview/ui/widgets/search_error_widget.dart';
import '../../../overview/ui/widgets/search_loading_indicator.dart';

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
      _SimpleSearchLocationFieldState();
}

class _SimpleSearchLocationFieldState
    extends ConsumerState<SearchLocationField> {
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
      setState(() => _results = []);
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
    return Column(
      children: [
        TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _search,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          const SearchLoadingIndicator()
        else if (_error != null)
          SearchErrorWidget(error: _error!)
        else if (_results.isEmpty)
          const EmptySearchResult()
        else
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (final context, final index) {
                final location = _results[index];
                return ListTile(
                  title: Text(location.name),
                  subtitle: Text(location.address),
                  onTap: () => widget.onSelected?.call(location),
                );
              },
            ),
          ),
      ],
    );
  }
}

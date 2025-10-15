import 'package:flutter/material.dart';

class AddPlaceModal extends StatefulWidget {
  const AddPlaceModal({super.key});

  @override
  State<AddPlaceModal> createState() => _AddPlaceModalState();
}

class _AddPlaceModalState extends State<AddPlaceModal> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (final notification) {
        // Unfocus để ẩn bàn phím khi user drag modal
        FocusScope.of(context).unfocus();
        return false;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (final context, final scrollController) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Center(
                  child: Text(
                    'Thêm Địa Điểm Yêu Thích',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    'Tìm kiếm và thêm địa điểm vào danh sách yêu thích của bạn',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Search Field
                TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Tìm kiếm địa điểm...',
                    // labelText: 'Tìm kiếm',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        if (_searchController.text.isNotEmpty) {
                          // Nếu có text → xóa text
                          setState(() {
                            _searchController.clear();
                          });
                        } else {
                          // Nếu không có text → đóng modal
                          Navigator.of(context).pop();
                        }
                      },
                      tooltip: _searchController.text.isNotEmpty
                          ? 'Xóa'
                          : 'Đóng',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                  ),
                  onChanged: (final value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),

                // Search Results / Empty State
                Expanded(
                  child: _searchController.text.isEmpty
                      ? _buildEmptyState()
                      : _buildSearchResults(scrollController),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Nhập tên địa điểm để tìm kiếm',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(final ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      children: [
        // Placeholder for search results
        _buildPlaceItem('Bãi biển Mỹ Khê', 'Đà Nẵng'),
        _buildPlaceItem('Cầu Rồng', 'Đà Nẵng'),
        _buildPlaceItem('Bà Nà Hills', 'Đà Nẵng'),
        _buildPlaceItem('Hội An Ancient Town', 'Quảng Nam'),
      ],
    );
  }

  Widget _buildPlaceItem(final String name, final String location) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: Handle place selection
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đã thêm "$name" vào danh sách yêu thích')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.place,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

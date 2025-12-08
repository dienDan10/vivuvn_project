import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// ignore: unused_import
import '../../itinerary/itinerary-detail/overview/data/dto/hotel_item_response.dart';
// ignore: unused_import
import '../../itinerary/itinerary-detail/overview/data/dto/restaurant_item_response.dart';
import '../../itinerary/itinerary-detail/overview/ui/widgets/favourite_place/place_card_image.dart';
import '../../itinerary/itinerary-detail/overview/ui/widgets/shared/location_action_buttons.dart';
import '../../itinerary/itinerary-detail/schedule/model/transportation_mode.dart';
import '../../itinerary/itinerary-detail/schedule/ui/widgets/schedule_place_card.dart';
import '../controller/public_itinerary_controller.dart';

class PublicItineraryViewScreen extends ConsumerStatefulWidget {
  final String itineraryId;

  const PublicItineraryViewScreen({
    required this.itineraryId,
    super.key,
  });

  @override
  ConsumerState<PublicItineraryViewScreen> createState() =>
      _PublicItineraryViewScreenState();
}

class _PublicItineraryViewScreenState
    extends ConsumerState<PublicItineraryViewScreen> {
  final Set<int> _expandedDays = {};
  bool _restaurantsExpanded = true;
  bool _hotelsExpanded = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(publicItineraryControllerProvider.notifier)
        ..setItineraryId(widget.itineraryId)
        ..loadItineraryDetail();
    });
  }

  void _toggleDay(final int dayId) {
    setState(() {
      if (_expandedDays.contains(dayId)) {
        _expandedDays.remove(dayId);
      } else {
        _expandedDays.add(dayId);
      }
    });
  }


  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(publicItineraryControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lịch trình')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lịch trình')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lỗi: ${state.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(publicItineraryControllerProvider.notifier)
                      .loadItineraryDetail();
                },
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.itinerary == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lịch trình')),
        body: const Center(child: Text('Không tìm thấy lịch trình')),
      );
    }

    final itinerary = state.itinerary!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Lịch trình'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (final String value) {
              if (value == 'join') {
                // TODO: Implement join itinerary API
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tính năng tham gia lịch trình đang được phát triển'),
                  ),
                );
              }
            },
            itemBuilder: (final BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'join',
                child: Row(
                  children: [
                    Icon(Icons.person_add, size: 20),
                    SizedBox(width: 12),
                    Text('Tham gia lịch trình'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Fixed image header with overlay
          Stack(
            children: [
              // Background image
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  itinerary.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (final context, final error, final stackTrace) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image, size: 64),
                  ),
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom overlay - Title and info in 2 columns
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 80, 16, 60),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.5),
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          itinerary.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Info in 2 columns
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Column 1: Province, Date
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Province
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Icon(
                                            Icons.location_on,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            itinerary.destinationProvinceName,
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    // Date
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Icon(
                                            Icons.calendar_today,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            '${DateFormat('dd/MM/yyyy').format(itinerary.startDate)} - ${DateFormat('dd/MM/yyyy').format(itinerary.endDate)}',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(width: 16),
                            // Column 2: Owner, Transportation, Members
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Owner info
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white.withValues(alpha: 0.5),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.white,
                                            backgroundImage: itinerary.owner.userPhoto != null
                                                ? NetworkImage(itinerary.owner.userPhoto!)
                                                : null,
                                            child: itinerary.owner.userPhoto == null
                                                ? const Icon(
                                                    Icons.person,
                                                    size: 16,
                                                    color: Colors.black87,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                itinerary.owner.username,
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              if (itinerary.owner.email.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2),
                                                  child: Text(
                                                    itinerary.owner.email,
                                                    style: theme.textTheme.bodySmall?.copyWith(
                                                      color: Colors.white.withValues(alpha: 0.8),
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const SizedBox(height: 8),
                                    // Transportation
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 2),
                                          child: Icon(
                                            itinerary.transportationVehicle.isNotEmpty
                                                ? TransportationMode.getIcon(itinerary.transportationVehicle)
                                                : Icons.directions,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            itinerary.transportationVehicle.isNotEmpty
                                                ? itinerary.transportationVehicle
                                                : 'Chưa cập nhật',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    // Members count
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Icon(
                                            Icons.group,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            '${state.members.length}/${itinerary.groupSize} người',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lịch trình theo ngày
                  if (state.days.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'Lịch trình',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Vertical expandable day list
                    ...state.days.map((final day) {
                            final date = day.date;
                      final dayLabel = date != null
                          ? DateFormat('EEE, dd/MM/yyyy', 'vi').format(date)
                                : 'Ngày ${day.dayNumber}';
                      final isExpanded = _expandedDays.contains(day.id);

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ExpansionTile(
                          title: Text(
                            dayLabel,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${day.items.length} địa điểm',
                            style: theme.textTheme.bodySmall,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.primary,
                            child: Text(
                              '${day.dayNumber}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          trailing: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                          ),
                          initiallyExpanded: isExpanded,
                          onExpansionChanged: (final expanded) {
                            _toggleDay(day.id);
                          },
                          children: [
                            if (day.items.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Chưa có địa điểm nào',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            else
                              ...day.items.map(
                                (final item) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  child: SchedulePlaceCard(item: item),
                                ),
                              ),
                            const SizedBox(height: 8),
                          ],
                              ),
                            );
                          }),
                  ],

                  // Nhà hàng
                  if (state.restaurants.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Nhà hàng',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _restaurantsExpanded ? Icons.expand_less : Icons.expand_more,
                            ),
                            onPressed: () {
                              setState(() {
                                _restaurantsExpanded = !_restaurantsExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    if (_restaurantsExpanded)
                      ...state.restaurants.map((final restaurant) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      restaurant.name,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (restaurant.address.isNotEmpty)
                                      Text(
                                        restaurant.address,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (restaurant.mealDate != null) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        'Thời gian: ${DateFormat('dd/MM/yyyy HH:mm', 'vi').format(restaurant.mealDate!)}',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                    if (restaurant.cost != null && restaurant.cost! > 0) ...[
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.attach_money, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${NumberFormat('#,###').format(restaurant.cost)} VNĐ',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (restaurant.note != null && restaurant.note!.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          restaurant.note!,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 8),
                                    LocationActionButtons(
                                      placeUri: restaurant.placeUri,
                                      directionsUri: restaurant.directionsUri,
                                      fallbackQuery: '${restaurant.name}, ${restaurant.address}',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              PlaceCardImage(
                                imageUrl: restaurant.imageUrl,
                                size: 120,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],

                  // Khách sạn
                  if (state.hotels.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Khách sạn',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _hotelsExpanded ? Icons.expand_less : Icons.expand_more,
                            ),
                            onPressed: () {
                              setState(() {
                                _hotelsExpanded = !_hotelsExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    if (_hotelsExpanded)
                      ...state.hotels.map((final hotel) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hotel.name,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (hotel.address.isNotEmpty)
                                      Text(
                                        hotel.address,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Nhận phòng: ${hotel.checkInDate != null ? DateFormat('dd/MM/yyyy', 'vi').format(hotel.checkInDate!) : '--/--'} - Trả phòng: ${hotel.checkOutDate != null ? DateFormat('dd/MM/yyyy', 'vi').format(hotel.checkOutDate!) : '--/--'}',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (hotel.cost != null && hotel.cost! > 0) ...[
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.attach_money, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${NumberFormat('#,###').format(hotel.cost)} VNĐ',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (hotel.note != null && hotel.note!.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          hotel.note!,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 8),
                                    LocationActionButtons(
                                      placeUri: hotel.placeUri,
                                      directionsUri: hotel.directionsUri,
                                      fallbackQuery: '${hotel.name}, ${hotel.address}',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              PlaceCardImage(
                                imageUrl: hotel.imageUrl,
                                size: 120,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


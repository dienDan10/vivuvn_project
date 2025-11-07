import '../../model/location.dart';

class GetLocationsResponse {
  final List<Location> locations;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  GetLocationsResponse({
    required this.locations,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory GetLocationsResponse.fromJson(final Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    return GetLocationsResponse(
      locations: data.map((final item) => Location.fromJson(item)).toList(),
      pageNumber: json['pageNumber'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? data.length,
      totalCount: json['totalCount'] as int? ?? data.length,
      totalPages: json['totalPages'] as int? ?? 1,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
    );
  }
}


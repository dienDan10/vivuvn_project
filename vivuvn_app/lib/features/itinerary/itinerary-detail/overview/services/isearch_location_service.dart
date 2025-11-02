import '../models/location.dart';

abstract interface class ISearchLocationService {
  Future<List<Location>> searchLocation(final String query);
}

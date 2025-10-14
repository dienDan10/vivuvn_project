import '../models/province.dart';

abstract interface class IcreateItineraryService {
  Future<List<Province>> searchProvince(final String queryText);
}

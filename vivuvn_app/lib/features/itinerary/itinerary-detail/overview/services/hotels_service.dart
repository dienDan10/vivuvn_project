import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/hotels_api.dart';
import '../data/dto/add_hotel_request.dart';
import '../data/dto/hotel_item_response.dart';
import '../modal/location.dart';

final hotelsServiceProvider = Provider.autoDispose<IHotelsService>((final ref) {
  final api = ref.watch(hotelsApiProvider);
  return HotelsService(api);
});

abstract class IHotelsService {
  Future<List<HotelItemResponse>> getHotels(final int itineraryId);
  Future<List<Location>> searchHotels({
    final String textQuery = '',
    final String? provinceName,
  });
  Future<void> addHotel({
    required final int itineraryId,
    required final AddHotelRequest request,
  });
  Future<void> updateHotelNote({
    required final int itineraryId,
    required final String id,
    required final String note,
  });
  Future<void> updateHotelDate({
    required final int itineraryId,
    required final String id,
    required final DateTime checkInDate,
    required final DateTime checkOutDate,
  });
  Future<void> updateHotelCost({
    required final int itineraryId,
    required final String id,
    required final double cost,
  });
  Future<void> deleteHotel({
    required final int itineraryId,
    required final String id,
  });
}

class HotelsService implements IHotelsService {
  final HotelsApi _api;

  HotelsService(this._api);

  @override
  Future<List<HotelItemResponse>> getHotels(final int itineraryId) async {
    return _api.getHotels(itineraryId);
  }

  @override
  Future<List<Location>> searchHotels({
    final String textQuery = '',
    final String? provinceName,
  }) async {
    return _api.searchHotels(textQuery: textQuery, provinceName: provinceName);
  }

  @override
  Future<void> addHotel({
    required final int itineraryId,
    required final AddHotelRequest request,
  }) async {
    await _api.addHotel(itineraryId: itineraryId, request: request);
  }

  @override
  Future<void> updateHotelNote({
    required final int itineraryId,
    required final String id,
    required final String note,
  }) async {
    await _api.updateHotelNote(itineraryId: itineraryId, id: id, note: note);
  }

  @override
  Future<void> updateHotelDate({
    required final int itineraryId,
    required final String id,
    required final DateTime checkInDate,
    required final DateTime checkOutDate,
  }) async {
    await _api.updateHotelDate(
      itineraryId: itineraryId,
      id: id,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
    );
  }

  @override
  Future<void> updateHotelCost({
    required final int itineraryId,
    required final String id,
    required final double cost,
  }) async {
    await _api.updateHotelCost(itineraryId: itineraryId, id: id, cost: cost);
  }

  @override
  Future<void> deleteHotel({
    required final int itineraryId,
    required final String id,
  }) async {
    await _api.deleteHotel(itineraryId: itineraryId, id: id);
  }
}

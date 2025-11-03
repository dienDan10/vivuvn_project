import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/data/remote/network/network_service.dart';
import '../dtos/delete_message_request.dart';
import '../dtos/get_messages_request.dart';
import '../dtos/get_new_messages_request.dart';
import '../dtos/send_message_request.dart';
import '../model/message.dart';

class MessageApi {
  final Dio _dio;
  MessageApi(this._dio);

  Future<List<Message>> getMessages(final GetMessagesRequest request) async {
    final response = await _dio.get(
      '/api/v1/itineraries/${request.itineraryId}/chat',
      queryParameters: {'page': request.page, 'pageSize': request.pageSize},
    );

    final data = response.data as List<dynamic>;
    return data
        .map((final e) => Message.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Message>> getNewMessages(
    final GetNewMessagesRequest request,
  ) async {
    final response = await _dio.get(
      '/api/v1/itineraries/${request.itineraryId}/chat/new',
      queryParameters: {'lastMessageId': request.lastMessageId},
    );

    final data = response.data as List<dynamic>;
    return data
        .map((final e) => Message.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<Message> sendMessage(final SendMessageRequest request) async {
    final response = await _dio.post(
      '/api/v1/itineraries/${request.itineraryId}/chat',
      data: {'message': request.message},
    );

    final data = response.data as Map<String, dynamic>;
    return Message.fromMap(data);
  }

  Future<void> deleteMessage(final DeleteMessageRequest request) async {
    await _dio.delete(
      '/api/v1/itineraries/${request.itineraryId}/chat/${request.messageId}',
    );
  }
}

final messageApiProvider = Provider<MessageApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return MessageApi(dio);
});

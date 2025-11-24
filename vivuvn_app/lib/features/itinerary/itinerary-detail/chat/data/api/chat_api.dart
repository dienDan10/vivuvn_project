import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/data/remote/network/network_service.dart';
import '../dtos/chat_update.dart';
import '../dtos/delete_message_request.dart';
import '../dtos/get_chat_update_request.dart';
import '../dtos/get_messages_request.dart';
import '../dtos/get_messages_response.dart';
import '../dtos/send_message_request.dart';
import '../model/message.dart';

class ChatApi {
  final Dio _dio;
  ChatApi(this._dio);

  Future<GetMessagesResponse> getMessages(
    final GetMessagesRequest request,
  ) async {
    final response = await _dio.get(
      '/api/v1/itineraries/${request.itineraryId}/chat',
      queryParameters: {'page': request.page, 'pageSize': request.pageSize},
    );

    final data = response.data as Map<String, dynamic>;
    return GetMessagesResponse.fromMap(data);
  }

  Future<ChatUpdate> getChatUpdates(final GetChatUpdateRequest request) async {
    final queryParams = <String, dynamic>{
      'lastMessageId': request.lastMessageId,
    };

    if (request.lastPolledAt != null) {
      queryParams['lastPolledAt'] = request.lastPolledAt!
          .toUtc()
          .toIso8601String();
    }
    final response = await _dio.get(
      '/api/v1/itineraries/${request.itineraryId}/chat/new',
      queryParameters: queryParams,
    );

    final data = response.data as Map<String, dynamic>;
    return ChatUpdate.fromMap(data);
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

final chatProvider = Provider.autoDispose<ChatApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return ChatApi(dio);
});

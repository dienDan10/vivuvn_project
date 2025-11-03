import '../data/dtos/get_messages_response.dart';
import '../data/model/message.dart';

abstract interface class IChatService {
  // Stream of new messages from polling
  Stream<List<Message>> get newMessagesStream;

  // Get paginated messages
  Future<GetMessagesResponse> getMessages({
    required final int itineraryId,
    final int page = 1,
    final int pageSize = 50,
  });

  // Get new messages for polling
  Future<List<Message>> getNewMessages({
    required final int itineraryId,
    required final int lastMessageId,
  });

  // Send a message
  Future<Message> sendMessage({
    required final int itineraryId,
    required final String message,
  });

  // Delete a message
  Future<void> deleteMessage({
    required final int itineraryId,
    required final int messageId,
  });

  // Start polling for new messages
  void startPolling({
    required final int itineraryId,
    required final int lastMessageId,
    final Duration interval = const Duration(seconds: 3),
  });

  // Stop polling
  void stopPolling();

  // Update last message ID for polling
  void updateLastMessageId(final int messageId);

  // Dispose resources
  void dispose();
}

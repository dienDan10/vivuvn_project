using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IItineraryMessageService
    {
        /// <summary>
        /// Get paginated messages for an itinerary
        /// </summary>
        Task<MessagePageResponseDto> GetMessagesAsync(
            int itineraryId,
            int userId,
            int page = 1,
            int pageSize = 50);

        /// <summary>
        /// Get new messages after a specific message ID (for polling)
        /// </summary>
        Task<ChatUpdateDto> GetChatUpdatesAsync(
            int itineraryId,
            int userId,
            int lastMessageId,
            DateTime? lastPolledAt);

        /// <summary>
        /// Send a new message
        /// </summary>
        Task<ItineraryMessageDto> SendMessageAsync(
            int itineraryId,
            int userId,
            SendMessageRequestDto request);

        /// <summary>
        /// Delete a message (soft delete)
        /// </summary>
        Task DeleteMessageAsync(int itineraryId, int messageId, int userId);
    }
}

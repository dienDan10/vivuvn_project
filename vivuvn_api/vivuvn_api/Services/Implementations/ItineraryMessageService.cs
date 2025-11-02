using AutoMapper;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryMessageService(IUnitOfWork _unitOfWork, IMapper _mapper) : IItineraryMessageService
    {

        public async Task<MessagePageResponseDto> GetMessagesAsync(int itineraryId, int userId, int page = 1, int pageSize = 50)
        {
            var (items, totalCount) = await _unitOfWork.ItineraryMessages.GetPagedAsync(
               filter: m => m.ItineraryId == itineraryId,
               includeProperties: "ItineraryMember,ItineraryMember.User",
               orderBy: q => q.OrderByDescending(m => m.CreatedAt),
               pageNumber: page,
               pageSize: pageSize);

            var messageDtos = _mapper.Map<List<ItineraryMessageDto>>(items);

            for (int i = 0; i < messageDtos.Count; i++)
            {
                var member = items.ElementAt(i).ItineraryMember;
                messageDtos[i].IsOwnMessage = member?.UserId == userId;
            }

            return new MessagePageResponseDto
            {
                Messages = messageDtos,
                CurrentPage = page,
                TotalPages = (int)Math.Ceiling((double)totalCount / pageSize),
                TotalMessages = totalCount,
                HasNextPage = page < (int)Math.Ceiling((double)totalCount / pageSize),
                HasPreviousPage = page > 1
            };
        }

        public async Task<List<ItineraryMessageDto>> GetNewMessagesAsync(int itineraryId, int userId, int lastMessageId)
        {
            var messages = await _unitOfWork.ItineraryMessages.GetAllAsync(
                filter: m => m.ItineraryId == itineraryId && m.Id > lastMessageId,
                includeProperties: "ItineraryMember,ItineraryMember.User",
                orderBy: q => q.OrderByDescending(m => m.CreatedAt));

            var messageDtos = _mapper.Map<List<ItineraryMessageDto>>(messages);
            for (int i = 0; i < messageDtos.Count; i++)
            {
                var member = messages.ElementAt(i).ItineraryMember;
                messageDtos[i].IsOwnMessage = member?.UserId == userId;
            }
            return messageDtos;
        }

        public Task<ItineraryMessageDto> SendMessageAsync(int itineraryId, int userId, SendMessageRequestDto request)
        {
            throw new NotImplementedException();
        }
        public Task<bool> DeleteMessageAsync(int messageId, int userId)
        {
            throw new NotImplementedException();
        }
    }
}

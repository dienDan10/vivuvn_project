using AutoMapper;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Models;
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

        public async Task<ItineraryMessageDto> SendMessageAsync(int itineraryId, int userId, SendMessageRequestDto request)
        {
            var member = await _unitOfWork.ItineraryMembers.GetOneAsync(m => m.ItineraryId == itineraryId && m.UserId == userId);

            var newMessage = new ItineraryMessage
            {
                ItineraryId = itineraryId,
                ItineraryMemberId = member!.Id,
                Message = request.Message,
                CreatedAt = DateTime.UtcNow
            };
            await _unitOfWork.ItineraryMessages.AddAsync(newMessage);
            await _unitOfWork.SaveChangesAsync();

            var savedMessage = await _unitOfWork.ItineraryMessages.GetOneAsync(
                m => m.Id == newMessage.Id,
                includeProperties: "ItineraryMember,ItineraryMember.User");

            var messageDto = _mapper.Map<ItineraryMessageDto>(savedMessage);
            messageDto.IsOwnMessage = userId == savedMessage?.ItineraryMember.UserId;

            return messageDto;
        }
        public async Task DeleteMessageAsync(int messageId, int userId)
        {
            var message = await _unitOfWork.ItineraryMessages.GetOneAsync(
                m => m.Id == messageId && m.ItineraryMember.UserId == userId)
                ?? throw new BadHttpRequestException("Message not found");

            _unitOfWork.ItineraryMessages.Remove(message);
            await _unitOfWork.SaveChangesAsync();
        }
    }
}

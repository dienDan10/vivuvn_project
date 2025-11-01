using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryMemberService(ITokenService _tokenService, IUnitOfWork _unitOfWork) : IItineraryMemberService
    {
        public async Task<InviteCodeDto> GenerateInviteCodeAsync(int itineraryId, int ownerId)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new ArgumentException("Itinerary not found");

            if (itinerary.UserId != ownerId)
            {
                throw new UnauthorizedAccessException("Only the itinerary owner can generate invite codes");
            }

            var inviteCode = new InviteCodeDto
            {
                InviteCode = _tokenService.CreateItineraryInviteToken(),
                GeneratedAt = DateTime.UtcNow
            };

            itinerary.InviteCode = inviteCode.InviteCode;
            itinerary.InviteCodeGeneratedAt = inviteCode.GeneratedAt;
            _unitOfWork.Itineraries.Update(itinerary);
            await _unitOfWork.SaveChangesAsync();

            return inviteCode;
        }

        public async Task JoinItineraryByInviteCodeAsync(int userId, string inviteCode)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.InviteCode == inviteCode)
                ?? throw new ArgumentException("Invalid invite code");

            // check if user is already a member
            var existingMember = await _unitOfWork.ItineraryMembers.GetOneAsync(im => im.ItineraryId == itinerary.Id && im.UserId == userId);

            if (existingMember is not null && !existingMember.DeleteFlag) // active member exists
            {
                throw new BadHttpRequestException("User is already a member of this itinerary");
            }

            if (existingMember is not null && existingMember.DeleteFlag) // inactive member exists
            {
                existingMember.DeleteFlag = false;
                _unitOfWork.ItineraryMembers.Update(existingMember);
                await _unitOfWork.SaveChangesAsync();
                return;
            }

            // add new member
            var newMember = new ItineraryMember
            {
                UserId = userId,
                ItineraryId = itinerary.Id,
                JoinedAt = DateTime.UtcNow,
                DeleteFlag = false
            };
            await _unitOfWork.ItineraryMembers.AddAsync(newMember);
            await _unitOfWork.SaveChangesAsync();
        }
    }
}

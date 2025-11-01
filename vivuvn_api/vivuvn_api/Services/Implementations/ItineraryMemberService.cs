using vivuvn_api.DTOs.ValueObjects;
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
    }
}

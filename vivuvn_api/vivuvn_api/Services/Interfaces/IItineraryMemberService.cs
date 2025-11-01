using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IItineraryMemberService
    {
        Task<InviteCodeDto> GenerateInviteCodeAsync(int itineraryId, int ownerId);
        Task JoinItineraryByInviteCodeAsync(int userId, string inviteCode);
        Task<IEnumerable<ItineraryMemberDto>> GetMembersAsync(int itineraryId);
    }
}

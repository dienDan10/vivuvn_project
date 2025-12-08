using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IItineraryMemberService
    {
        Task<InviteCodeDto> GenerateInviteCodeAsync(int itineraryId, int ownerId);
        Task JoinItineraryByInviteCodeAsync(int userId, string inviteCode);
        Task JoinPublicItineraryAsync(int userId, int itineraryId);
        Task<IEnumerable<ItineraryMemberDto>> GetMembersAsync(int itineraryId);
        Task LeaveItineraryAsync(int userId, int itineraryId);
        Task KickMemberAsync(int userId, int itineraryId, int memberId);

        // Helper methods
        Task<bool> IsOwnerAsync(int itineraryId, int userId);
        // check if user is a member of the itinerary include owners
        Task<bool> IsMemberAsync(int itineraryId, int userId);
        Task<int> GetCurrentMemberCountAsync(int itineraryId);
    }
}

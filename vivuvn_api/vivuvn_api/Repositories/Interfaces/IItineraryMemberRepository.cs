using vivuvn_api.Models;

namespace vivuvn_api.Repositories.Interfaces
{
    public interface IItineraryMemberRepository : IRepository<ItineraryMember>
    {
        Task<bool> IsMemberAsync(int itineraryId, int userId);

        Task<int> CountAsync(int itineraryId);
    }
}

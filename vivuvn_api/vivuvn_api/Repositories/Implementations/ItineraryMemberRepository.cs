using Microsoft.EntityFrameworkCore;
using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class ItineraryMemberRepository : Repository<ItineraryMember>, IItineraryMemberRepository
    {
        public ItineraryMemberRepository(AppDbContext context) : base(context)
        {
        }

        public async Task<bool> IsMemberAsync(int itineraryId, int userId)
        {
            var isMemberRole = await _context.ItineraryMembers
                .AnyAsync(im => im.ItineraryId == itineraryId
                && !im.DeleteFlag
                && im.User.Id == userId);
            return isMemberRole;
        }

        public async Task<int> CountAsync(int itineraryId)
        {
            return await _context.ItineraryMembers
                .CountAsync(im => im.ItineraryId == itineraryId && !im.DeleteFlag);
        }
    }
}

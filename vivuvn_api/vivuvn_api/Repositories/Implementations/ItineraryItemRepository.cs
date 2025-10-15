using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class ItineraryItemRepository : Repository<ItineraryItem>, IItineraryItemRepository
    {
        public ItineraryItemRepository(AppDbContext context) : base(context)
        {
        }
    }
}

using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class ItineraryMessageRepository : Repository<ItineraryMessage>, IItineraryMessageRepository
    {
        public ItineraryMessageRepository(AppDbContext context) : base(context)
        {
        }
    }
}

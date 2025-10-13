using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class ItineraryRepository : Repository<Itinerary>, IItineraryRepository
    {
        public ItineraryRepository(AppDbContext context) : base(context)
        {
        }
    }
}

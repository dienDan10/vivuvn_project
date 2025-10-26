using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class ItineraryRestaurantRepository : Repository<ItineraryRestaurant>, IItineraryRestaurantRepository
    {
        public ItineraryRestaurantRepository(AppDbContext context) : base(context)
        {
        }
    }
}

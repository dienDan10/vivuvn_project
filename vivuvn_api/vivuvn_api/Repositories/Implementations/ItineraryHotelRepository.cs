using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class ItineraryHotelRepository : Repository<ItineraryHotel>, IItineraryHotelRepository
    {
        public ItineraryHotelRepository(AppDbContext context) : base(context)
        {
        }
    }
}

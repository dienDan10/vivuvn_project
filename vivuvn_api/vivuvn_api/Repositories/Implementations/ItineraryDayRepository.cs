using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class ItineraryDayRepository : Repository<ItineraryDay>, IItineraryDayRepository
    {
        public ItineraryDayRepository(AppDbContext context) : base(context)
        {
        }
    }
}

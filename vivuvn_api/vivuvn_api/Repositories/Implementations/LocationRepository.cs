using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class LocationRepository : Repository<Location>, ILocationRepository
    {
        public LocationRepository(AppDbContext context) : base(context)
        {
        }


    }
}

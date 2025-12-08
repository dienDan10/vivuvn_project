using vivuvn_api.Models;

namespace vivuvn_api.Repositories.Interfaces
{
    public interface ILocationRepository : IRepository<Location>
    {
        Task<IEnumerable<Location>> GetTopTravelLocation(int limit);
    }
}

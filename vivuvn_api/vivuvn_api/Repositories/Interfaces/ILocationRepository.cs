using System.Linq.Expressions;
using vivuvn_api.Models;

namespace vivuvn_api.Repositories.Interfaces
{
    public interface ILocationRepository : IRepository<Location>
    {
        Task<IEnumerable<Location>> SearchLocationsAsync(Expression<Func<Location, bool>>? filter, int? limit);
    }
}

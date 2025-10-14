using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
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

        public async Task<IEnumerable<Location>> SearchLocationsAsync(Expression<Func<Location, bool>>? filter, int? limit)
        {
            IQueryable<Location> query = dbSet;
            if (filter != null)
            {
                query = query.Where(filter);
            }
            if (limit.HasValue)
            {
                query = query.Take(limit.Value);
            }
            return await query.ToListAsync();
        }
    }
}

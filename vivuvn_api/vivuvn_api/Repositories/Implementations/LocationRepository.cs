using Microsoft.EntityFrameworkCore;
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

        public async Task<IEnumerable<Location>> GetTopTravelLocation(int limit)
        {
            var topLocationIds = await _context.ItineraryItems
                .Where(ii => ii.LocationId != null)
                .GroupBy(ii => ii.LocationId)
                .Select(g => new
                {
                    LocationId = g.Key!.Value,
                    ReferenceCount = g.Count()
                })
                .OrderByDescending(x => x.ReferenceCount)
                .Take(limit)
                .Select(x => x.LocationId)
                .ToListAsync();

            var topLocations = await _context.Locations
                .Where(l => topLocationIds.Contains(l.Id))
                .Include(l => l.Photos)
                .Include(l => l.Province)
                .ToListAsync();

            return topLocations;

        }
    }
}

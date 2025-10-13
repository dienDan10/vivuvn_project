using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class ProvinceRepository : Repository<Province>, IProvinceRepository
    {
        public ProvinceRepository(AppDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<Province>> SearchProvincesAsync(Expression<Func<Province, bool>>? filter, int? limit)
        {
            IQueryable<Province> query = dbSet;
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

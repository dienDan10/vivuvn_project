using System.Linq.Expressions;
using vivuvn_api.Models;

namespace vivuvn_api.Repositories.Interfaces
{
    public interface IProvinceRepository : IRepository<Province>
    {
        Task<IEnumerable<Province>> SearchProvincesAsync(Expression<Func<Province, bool>>? filter, int? limit);
    }
}

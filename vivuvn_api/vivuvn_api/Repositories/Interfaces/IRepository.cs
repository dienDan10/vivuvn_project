using System.Linq.Expressions;

namespace vivuvn_api.Repositories.Interfaces
{
    public interface IRepository<T> where T : class
    {
        Task<IEnumerable<T>> GetAllAsync(Expression<Func<T, bool>>? filter = null,
            string? includeProperties = null,
            Func<IQueryable<T>, IOrderedQueryable<T>>? orderBy = null,
            int? limit = null);
        Task<(IEnumerable<T> items, int totalCount)> GetPagedAsync(
            Expression<Func<T, bool>>? filter = null,
            string? includeProperties = null,
            Func<IQueryable<T>, IOrderedQueryable<T>>? orderBy = null,
            int pageNumber = 1,
            int pageSize = 10);
        Task<T?> GetByIdAsync(int id);
        Task<T?> GetOneAsync(Expression<Func<T, bool>> filter, string? includeProperties = null, bool tracked = false);
        Task<T?> AddAsync(T entity);
        Task AddRangeAsync(IEnumerable<T> entities);
        void Update(T entity);
        void Remove(T entity);
        void RemoveRange(IEnumerable<T> entities);
    }
}

﻿using System.Linq.Expressions;

namespace vivuvn_api.Repositories.Interfaces
{
    public interface IRepository<T> where T : class
    {
        Task<IEnumerable<T>> GetAllAsync(Expression<Func<T, bool>>? filter = null, string? includeProperties = null);
        Task<T?> GetByIdAsync(int id);
        Task<T?> GetOneAsync(Expression<Func<T, bool>> filter, string? includeProperties = null, bool tracked = false);
        Task<T?> AddAsync(T entity);
        Task AddRangeAsync(IEnumerable<T> entities);
        void Update(T entity);
        void Remove(T entity);
        void RemoveRange(IEnumerable<T> entities);
    }
}

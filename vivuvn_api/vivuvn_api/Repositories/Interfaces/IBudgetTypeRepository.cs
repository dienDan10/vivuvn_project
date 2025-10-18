using vivuvn_api.Models;

namespace vivuvn_api.Repositories.Interfaces
{
    public interface IBudgetTypeRepository : IRepository<BudgetType>
    {
        Task<BudgetType?> GetByNameAsync(string name);
    }
}

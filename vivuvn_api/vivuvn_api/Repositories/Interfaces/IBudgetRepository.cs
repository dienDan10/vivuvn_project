using vivuvn_api.Models;

namespace vivuvn_api.Repositories.Interfaces
{
    public interface IBudgetRepository : IRepository<Budget>
    {
        Task<BudgetItem?> AddBudgetItemAsync(BudgetItem item);
        Task<BudgetItem?> GetBudgetItemByIdAsync(int id);
    }
}

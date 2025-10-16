using vivuvn_api.Models;

namespace vivuvn_api.Repositories.Interfaces
{
    public interface IBudgetRepository : IRepository<Budget>
    {
        Task<IEnumerable<BudgetItem>> GetBudgetItemsByBudgetIdAsync(int budgetId);
        Task<BudgetItem?> GetBudgetItemByIdAsync(int id);
        Task<BudgetItem?> AddBudgetItemAsync(BudgetItem item);
        Task<BudgetItem?> UpdateBudgetItemAsync(BudgetItem item);
    }
}

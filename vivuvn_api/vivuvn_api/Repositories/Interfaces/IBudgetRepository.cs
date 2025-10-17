using vivuvn_api.Models;

namespace vivuvn_api.Repositories.Interfaces
{
    public interface IBudgetRepository : IRepository<Budget>
    {

        Task<IEnumerable<BudgetItem>> GetBudgetItemsByBudgetIdAsync(int budgetId);
        Task<BudgetItem?> GetBudgetItemByIdAsync(int id, bool track = false);
        Task<BudgetItem?> AddBudgetItemAsync(BudgetItem item);
        Task<BudgetItem?> UpdateBudgetItemAsync(BudgetItem item);
        Task<BudgetItem?> DeleteBudgetItemAsync(int id);

    }
}

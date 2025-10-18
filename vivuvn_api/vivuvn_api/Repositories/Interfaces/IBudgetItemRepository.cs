using vivuvn_api.Models;

namespace vivuvn_api.Repositories.Interfaces
{
    public interface IBudgetItemRepository : IRepository<BudgetItem>
    {
        Task<IEnumerable<BudgetItem>> GetByBudgetIdAsync(int budgetId);
        Task<BudgetItem?> GetByIdWithDetailsAsync(int id);
    }
}

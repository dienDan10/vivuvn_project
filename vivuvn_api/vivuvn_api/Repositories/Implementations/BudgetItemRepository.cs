using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class BudgetItemRepository : Repository<BudgetItem>, IBudgetItemRepository
    {
        public BudgetItemRepository(AppDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<BudgetItem>> GetByBudgetIdAsync(int budgetId)
        {
            return await GetAllAsync(
                filter: bi => bi.BudgetId == budgetId,
                includeProperties: "BudgetType"
            );
        }

        public async Task<BudgetItem?> GetByIdWithDetailsAsync(int id)
        {
            return await GetOneAsync(
                filter: bi => bi.Id == id,
                includeProperties: "BudgetType,Budget"
            );
        }
    }
}

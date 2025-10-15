using Microsoft.EntityFrameworkCore;
using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class BudgetRepository : Repository<Budget>, IBudgetRepository
    {
        public BudgetRepository(AppDbContext context) : base(context)
        {
        }

        public async Task<BudgetItem?> AddBudgetItemAsync(BudgetItem item)
        {
            //get the budget from db
            var budget = await _context.Budgets
                .Where(b => b.BudgetId == item.BudgetId)
                .Include(b => b.Items)
                .FirstOrDefaultAsync();

            if (budget == null)
            {
                throw new ArgumentException($"Budget with ID {item.BudgetId} does not exist.");
            }

            // add the item to the budget
            budget.Items.Add(item);
            budget.TotalBudget += item.Cost;

            _context.Budgets.Update(budget);
            return item;
        }

        public async Task<BudgetItem?> GetBudgetItemByIdAsync(int id)
        {
            return await _context.BudgetItems
                .Where(i => i.Id == id)
                .Include(i => i.BudgetType)
                .FirstOrDefaultAsync();
        }

        public async Task<IEnumerable<BudgetItem>> GetBudgetItemsByBudgetIdAsync(int budgetId)
        {
            return await _context.BudgetItems
                .Where(i => i.BudgetId == budgetId)
                .Include(i => i.BudgetType)
                .ToListAsync();
        }
    }
}

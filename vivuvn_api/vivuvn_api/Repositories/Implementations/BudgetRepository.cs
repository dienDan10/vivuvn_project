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

        public async Task<BudgetItem?> UpdateBudgetItemAsync(BudgetItem item)
        {
            //get the budget from db
            var budget = await _context.Budgets
                .Include(b => b.Items)
                .FirstOrDefaultAsync(b => b.BudgetId == item.BudgetId);

            if (budget == null)
            {
                throw new ArgumentException($"Budget with ID {item.BudgetId} does not exist.");
            }

            // find the existing item in the budget
            var existingItem = budget.Items.FirstOrDefault(i => i.Id == item.Id);
            if (existingItem == null)
                throw new ArgumentException($"Budget item with ID {item.Id} does not exist.");

            // update the total budget
            budget.TotalBudget -= existingItem.Cost;
            budget.TotalBudget += item.Cost;

            // update the item in the budget
            existingItem.Name = item.Name;
            existingItem.Date = item.Date;
            existingItem.Cost = item.Cost;
            existingItem.BudgetTypeId = item.BudgetTypeId;


            _context.BudgetItems.Update(existingItem);
            _context.Budgets.Update(budget);

            await _context.SaveChangesAsync();

            var updatedItem = await GetBudgetItemByIdAsync(item.Id);

            return updatedItem;
        }
    }
}

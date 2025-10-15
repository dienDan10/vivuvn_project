using AutoMapper;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class BudgetService(IUnitOfWork _unitOfWork, IMapper _mapper) : IBudgetService
    {
        public async Task<IEnumerable<BudgetItemDto>> GetBudgetItemsAsync(int itineraryId)
        {
            var budget = await _unitOfWork.Budgets.GetOneAsync(b => b.ItineraryId == itineraryId);
            if (budget == null)
            {
                throw new ArgumentException($"Budget for Itinerary ID {itineraryId} does not exist.");
            }
            var budgetItems = await _unitOfWork.Budgets.GetBudgetItemsByBudgetIdAsync(budget.BudgetId);

            return _mapper.Map<IEnumerable<BudgetItemDto>>(budgetItems);
        }

        public async Task<BudgetItemDto?> AddBudgetItemAsync(int itineraryId, CreateBudgetItemRequestDto item)
        {
            var budget = await _unitOfWork.Budgets.GetOneAsync(b => b.ItineraryId == itineraryId);

            if (budget == null)
            {
                throw new ArgumentException($"Budget for Itinerary ID {itineraryId} does not exist.");
            }

            var budgetItem = new BudgetItem
            {
                Name = item.Name ?? "New Budget Item",
                BudgetId = budget.BudgetId,
                Cost = item.Cost,
                Date = item.Date,
                BudgetTypeId = item.BudgetTypeId
            };

            await _unitOfWork.Budgets.AddBudgetItemAsync(budgetItem);
            await _unitOfWork.SaveChangesAsync();

            budgetItem = await _unitOfWork.Budgets.GetBudgetItemByIdAsync(budgetItem.Id);

            return _mapper.Map<BudgetItemDto>(budgetItem);
        }
    }
}

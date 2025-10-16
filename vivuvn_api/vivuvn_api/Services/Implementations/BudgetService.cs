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

        public async Task<BudgetItemDto?> UpdateBudgetItemAsync(int itemId, UpdateBudgetItemRequestDto request)
        {
            var item = await _unitOfWork.Budgets.GetBudgetItemByIdAsync(itemId, track: false);

            if (item is null)
            {
                throw new ArgumentException($"Budget item with ID {itemId} does not exist.");
            }

            if (request.Name is not null) item.Name = request.Name;

            if (request.Date is not null) item.Date = request.Date.Value;

            if (request.Cost is not null && request.Cost.Value > 0) item.Cost = request.Cost.Value;

            if (request.BudgetTypeId is not null) item.BudgetTypeId = request.BudgetTypeId.Value;

            var updatedItem = await _unitOfWork.Budgets.UpdateBudgetItemAsync(item);

            await _unitOfWork.SaveChangesAsync();

            return _mapper.Map<BudgetItemDto>(updatedItem);
        }

        public async Task<BudgetItemDto?> DeleteBudgetItemAsync(int itemId)
        {
            var deletedItem = await _unitOfWork.Budgets.DeleteBudgetItemAsync(itemId);
            await _unitOfWork.SaveChangesAsync();
            return _mapper.Map<BudgetItemDto>(deletedItem);
        }
    }
}

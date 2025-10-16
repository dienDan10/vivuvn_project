using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IBudgetService
    {
        Task<IEnumerable<BudgetItemDto>> GetBudgetItemsAsync(int itineraryId);
        Task<BudgetItemDto?> AddBudgetItemAsync(int itineraryId, CreateBudgetItemRequestDto item);
        Task<BudgetItemDto?> UpdateBudgetItemAsync(int itemId, UpdateBudgetItemRequestDto request);
        Task<BudgetItemDto?> DeleteBudgetItemAsync(int itemId);
    }
}

using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IBudgetService
    {
        Task<BudgetItemDto?> AddBudgetItemAsync(int itineraryId, CreateBudgetItemRequestDto item);
    }
}

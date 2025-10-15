using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IItineraryItemService
    {
        Task AddItemToDayAsync(int dayId, AddItineraryDayItemRequestDto request);
        Task<IEnumerable<ItineraryItemDto>> GetItemsByDayIdAsync(int dayId);
        Task RemoveItemFromDayAsync(int dayId, int itemId);
        Task<ItineraryItemDto> UpdateItineraryItemAsync(int itemId, UpdateItineraryItemRequestDto request);
    }
}

using vivuvn_api.DTOs.Request;

namespace vivuvn_api.Services.Interfaces
{
    public interface IItineraryItemService
    {
        Task AddItemToDayAsync(int itineraryId, int dayId, AddItineraryDayItemRequestDto request);
    }
}

using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IitineraryHotelService
    {
        Task<IEnumerable<ItineraryHotelDto>> GetHotelsInItineraryAsync(int itineraryId);
        Task AddHotelToItineraryFromSuggestionAsync(int itineraryId, AddHotelToItineraryFromSuggestionDto request);
    }
}

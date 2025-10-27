using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IitineraryRestaurantService
    {
        Task<IEnumerable<ItineraryRestaurantDto>> GetRestaurantsInItineraryAsync(int itineraryId);
        Task AddRestaurantToItineraryFromSuggestionAsync(int itineraryId, AddRestaurantToItineraryFromSuggestionDto request);
        Task AddRestaurantToItineraryFromSearchAsync(int itineraryId, AddRestaurantToItineraryFromSearch request);
        Task UpdateNotesAsync(int itineraryId, int itineraryRestaurantId, string notes);
        Task UpdateDateAsync(int itineraryId, int itineraryRestaurantId, DateOnly date);
        Task UpdateTimeAsync(int itineraryId, int itineraryRestaurantId, TimeOnly time);
    }
}

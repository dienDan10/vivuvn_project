using vivuvn_api.DTOs.Request;

namespace vivuvn_api.Services.Interfaces
{
    public interface IitineraryRestaurantService
    {
        Task AddRestaurantToItineraryFromSuggestionAsync(int itineraryId, AddRestaurantToItineraryFromSuggestionDto request);

        Task AddRestaurantToItineraryFromSearchAsync(int itineraryId, AddRestaurantToItineraryFromSearch request);
    }
}

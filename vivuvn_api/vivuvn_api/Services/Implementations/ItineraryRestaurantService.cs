using vivuvn_api.DTOs.Request;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryRestaurantService(IUnitOfWork _unitOfWork) : IitineraryRestaurantService
    {
        public Task AddRestaurantToItineraryFromSuggestionAsync(int itineraryId, AddRestaurantToItineraryFromSuggestionDto request)
        {
            throw new NotImplementedException();
        }
    }
}

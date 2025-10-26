using vivuvn_api.DTOs.Request;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryRestaurantService(IUnitOfWork _unitOfWork) : IitineraryRestaurantService
    {
        public async Task AddRestaurantToItineraryFromSuggestionAsync(int itineraryId, AddRestaurantToItineraryFromSuggestionDto request)
        {
            var itinerary = _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new BadHttpRequestException("Itinerary not found");

            var itineraryRestaurant = new ItineraryRestaurant
            {
                ItineraryId = itineraryId,
                RestaurantId = request.RestaurantId
            };

            await _unitOfWork.ItineraryRestaurants.AddAsync(itineraryRestaurant);
            await _unitOfWork.SaveChangesAsync();
        }
    }
}

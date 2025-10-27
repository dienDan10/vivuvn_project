using AutoMapper;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryRestaurantService(IUnitOfWork _unitOfWork, IGoogleMapPlaceService _placeService, IMapper _mapper, IJsonService _jsonService) : IitineraryRestaurantService
    {
        public async Task<IEnumerable<ItineraryRestaurantDto>> GetRestaurantsInItineraryAsync(int itineraryId)
        {
            var itineraryRestaurants = await _unitOfWork.ItineraryRestaurants.GetAllAsync(ir => ir.ItineraryId == itineraryId, includeProperties: "Restaurant,BudgetItem");
            var itineraryRestaurantDtos = _mapper.Map<IEnumerable<ItineraryRestaurantDto>>(itineraryRestaurants);
            return itineraryRestaurantDtos;
        }

        public async Task AddRestaurantToItineraryFromSuggestionAsync(int itineraryId, AddRestaurantToItineraryFromSuggestionDto request)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new BadHttpRequestException("Itinerary not found");

            var itineraryRestaurant = new ItineraryRestaurant
            {
                ItineraryId = itineraryId,
                RestaurantId = request.RestaurantId
            };

            await _unitOfWork.ItineraryRestaurants.AddAsync(itineraryRestaurant);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task AddRestaurantToItineraryFromSearchAsync(int itineraryId, AddRestaurantToItineraryFromSearch request)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new BadHttpRequestException("Itinerary not found");

            var restaurant = await _unitOfWork.Restaurants.GetOneAsync(r => r.GooglePlaceId == request.GooglePlaceId);

            // if restaurant exists in db, use it
            if (restaurant != null)
            {
                await _unitOfWork.ItineraryRestaurants.AddAsync(new ItineraryRestaurant
                {
                    ItineraryId = itineraryId,
                    RestaurantId = restaurant.Id,
                    Date = request.Date,
                    Time = request.Time
                });
                await _unitOfWork.SaveChangesAsync();
                return;
            }

            // else, fetch from google place api and add to db
            var place = await _placeService.FetchPlaceDetailsByIdAsync(request.GooglePlaceId)
                ?? throw new BadHttpRequestException("Fail to add restaurant. Cannot find restaurant data");

            var restaurantDto = _mapper.Map<RestaurantDto>(place);

            var newRestaurant = _mapper.Map<Restaurant>(restaurantDto);

            await _unitOfWork.Restaurants.AddAsync(newRestaurant);
            await _unitOfWork.SaveChangesAsync();

            var itineraryRestaurant = new ItineraryRestaurant
            {
                ItineraryId = itineraryId,
                RestaurantId = newRestaurant.Id,
                Date = request.Date,
                Time = request.Time
            };
            await _unitOfWork.ItineraryRestaurants.AddAsync(itineraryRestaurant);
            await _unitOfWork.SaveChangesAsync();

            // save restaurant data to json file for caching
            await _jsonService.SaveSingleRestaurantToJsonFile(newRestaurant);
        }

        public async Task UpdateNotesAsync(int itineraryId, int itineraryRestaurantId, string notes)
        {
            var itineraryRestaurant = await _unitOfWork.ItineraryRestaurants.GetOneAsync(ir => ir.Id == itineraryRestaurantId && ir.ItineraryId == itineraryId)
                ?? throw new BadHttpRequestException("Itinerary restaurant not found");
            itineraryRestaurant.Notes = notes;
            _unitOfWork.ItineraryRestaurants.Update(itineraryRestaurant);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task UpdateDateAsync(int itineraryId, int itineraryRestaurantId, DateOnly date)
        {
            var itineraryRestaurant = await _unitOfWork.ItineraryRestaurants
                .GetOneAsync(ir => ir.Id == itineraryRestaurantId && ir.ItineraryId == itineraryId)
                ?? throw new BadHttpRequestException("Itinerary restaurant not found");
            itineraryRestaurant.Date = date;
            _unitOfWork.ItineraryRestaurants.Update(itineraryRestaurant);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task UpdateTimeAsync(int itineraryId, int itineraryRestaurantId, TimeOnly time)
        {
            var itineraryRestaurant = await _unitOfWork.ItineraryRestaurants
                .GetOneAsync(ir => ir.Id == itineraryRestaurantId && ir.ItineraryId == itineraryId)
                ?? throw new BadHttpRequestException("Itinerary restaurant not found");
            itineraryRestaurant.Time = time;
            _unitOfWork.ItineraryRestaurants.Update(itineraryRestaurant);
            await _unitOfWork.SaveChangesAsync();
        }

    }
}

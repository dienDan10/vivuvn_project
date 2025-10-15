using vivuvn_api.DTOs.Request;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryItemService(IUnitOfWork _unitOfWork) : IItineraryItemService
    {
        public async Task AddItemToDayAsync(int itineraryId, int dayId, AddItineraryDayItemRequestDto request)
        {
            var itineraryDayItem = new ItineraryItem
            {
                ItineraryDayId = dayId,
                LocationId = request.LocationId,
                OrderIndex = request.OrderIndex,
                TransportationVehicle = Constants.TravelMode_Driving, // default to driving
                TransportationDistance = 500, // in meters
                TransportationDuration = 278, // in seconds
            };

            // fetch transportation details if order index is greater than 1
            await _unitOfWork.ItineraryItems.AddAsync(itineraryDayItem);
        }
    }
}

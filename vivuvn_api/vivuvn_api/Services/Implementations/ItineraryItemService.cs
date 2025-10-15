using AutoMapper;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryItemService(IUnitOfWork _unitOfWork, IMapper _mapper) : IItineraryItemService
    {
        public async Task AddItemToDayAsync(int dayId, AddItineraryDayItemRequestDto request)
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
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task<IEnumerable<ItineraryItemDto>> GetItemsByDayIdAsync(int dayId)
        {
            var items = await _unitOfWork.ItineraryItems.GetAllAsync(i => i.ItineraryDayId == dayId,
                includeProperties: "Location,Location.LocationPhotos,Location.Province",
                orderBy: q => q.OrderBy(i => i.OrderIndex));

            return _mapper.Map<IEnumerable<ItineraryItemDto>>(items);
        }
    }
}

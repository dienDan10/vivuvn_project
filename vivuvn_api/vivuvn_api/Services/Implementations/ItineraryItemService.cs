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
            // get the order index
            var existingItems = await _unitOfWork.ItineraryItems.GetAllAsync(i => i.ItineraryDayId == dayId);
            int orderIndex = existingItems?.Count() + 1 ?? 1;

            var itineraryDayItem = new ItineraryItem
            {
                ItineraryDayId = dayId,
                LocationId = request.LocationId,
                OrderIndex = orderIndex,
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

        public async Task RemoveItemFromDayAsync(int dayId, int itemId)
        {
            var item = await _unitOfWork.ItineraryItems.GetOneAsync(i => i.ItineraryItemId == itemId && i.ItineraryDayId == dayId);

            if (item is null) throw new KeyNotFoundException($"Itinerary item with id {itemId} not found in day {dayId}.");

            var itemsToUpdate = await _unitOfWork.ItineraryItems.GetAllAsync(i => i.ItineraryDayId == dayId && i.OrderIndex > item.OrderIndex);

            _unitOfWork.ItineraryItems.Remove(item);
            await _unitOfWork.SaveChangesAsync();

            if (itemsToUpdate is null || !itemsToUpdate.Any()) return;

            // readjust order index of remaining items
            foreach (var remainingItem in itemsToUpdate)
            {
                remainingItem.OrderIndex--;
            }
            await _unitOfWork.SaveChangesAsync();
        }
    }
}

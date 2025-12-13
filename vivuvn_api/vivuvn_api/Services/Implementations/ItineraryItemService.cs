using AutoMapper;
using Microsoft.EntityFrameworkCore;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryItemService(IUnitOfWork _unitOfWork, IMapper _mapper, IGoogleMapRouteService _routeService) : IItineraryItemService
    {
        public async Task AddItemToDayAsync(int dayId, AddItineraryDayItemRequestDto request)
        {
            // get the order index
            var existingItems = await _unitOfWork.ItineraryItems.GetAllAsync(i => i.ItineraryDayId == dayId);
            int orderIndex = existingItems?.Count() + 1 ?? 1;

            var newItem = new ItineraryItem
            {
                ItineraryDayId = dayId,
                LocationId = request.LocationId,
                OrderIndex = orderIndex,
                TransportationVehicle = Constants.TravelMode_Driving, // default to driving
                TransportationDistance = 500, // in meters
                TransportationDuration = 278, // in seconds
            };

            if (orderIndex > 1) // get transportation details for items that are not the first in the day
            {
                var prevItem = await _unitOfWork.ItineraryItems.GetOneAsync(i =>
                    i.ItineraryDayId == dayId && i.OrderIndex == orderIndex - 1);

                if (prevItem is not null)
                {
                    try
                    {
                        await UpdateTransportationDetailsAsync(prevItem, newItem);
                    }
                    catch
                    {

                    }
                }
            }

            // fetch transportation details if order index is greater than 1
            await _unitOfWork.ItineraryItems.AddAsync(newItem);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task<IEnumerable<ItineraryItemDto>> GetItemsByDayIdAsync(int dayId)
        {
            return await _unitOfWork.ItineraryItems
                .GetQueryable()
                .Where(i => i.ItineraryDayId == dayId)
                .OrderBy(i => i.OrderIndex)
                .Select(i => new ItineraryItemDto
                {
                    ItineraryItemId = i.ItineraryItemId,
                    OrderIndex = i.OrderIndex,
                    Note = i.Note,
                    EstimateDuration = i.EstimateDuration,
                    StartTime = i.StartTime,
                    EndTime = i.EndTime,
                    TransportationVehicle = i.TransportationVehicle,
                    TransportationDuration = i.TransportationDuration,
                    TransportationDistance = i.TransportationDistance,
                    Location = new LocationDto
                    {
                        Id = i.Location.Id,
                        Name = i.Location.Name,
                        ProvinceName = i.Location.Province.Name,
                        Description = i.Location.Description,
                        Latitude = i.Location.Latitude,
                        Longitude = i.Location.Longitude,
                        Address = i.Location.Address,
                        Rating = i.Location.Rating,
                        RatingCount = i.Location.RatingCount,
                        GooglePlaceId = i.Location.GooglePlaceId,
                        PlaceUri = i.Location.PlaceUri,
                        DirectionsUri = i.Location.DirectionsUri,
                        ReviewUri = i.Location.ReviewUri,
                        WebsiteUri = i.Location.WebsiteUri,
                        DeleteFlag = i.Location.DeleteFlag,
                        Photos = i.Location.Photos
                            .Select(p => p.PhotoUrl)
                            .ToList()
                    }
                })
                .AsNoTracking()
                .ToListAsync();
        }

        public async Task RemoveItemFromDayAsync(int dayId, int itemId)
        {
            await _unitOfWork.BeginTransactionAsync();

            try
            {
                var item = await _unitOfWork.ItineraryItems
                    .GetOneAsync(i => i.ItineraryItemId == itemId && i.ItineraryDayId == dayId)
                    ?? throw new KeyNotFoundException($"Không tìm thấy mục lịch trình có ID {itemId} trong ngày {dayId}.");

                var itemsToUpdate = await _unitOfWork.ItineraryItems.GetAllAsync(
                    i => i.ItineraryDayId == dayId && i.OrderIndex > item.OrderIndex,
                    orderBy: q => q.OrderBy(i => i.OrderIndex)
                );

                _unitOfWork.ItineraryItems.Remove(item);
                await _unitOfWork.SaveChangesAsync();

                if (itemsToUpdate is null || !itemsToUpdate.Any())
                {
                    await _unitOfWork.CommitTransactionAsync();
                    return;
                }

                // Recalculate distance and travel time
                var prevItem = await _unitOfWork.ItineraryItems.GetOneAsync(i =>
                    i.ItineraryDayId == dayId && i.OrderIndex == item.OrderIndex - 1);

                if (prevItem is not null)
                {
                    var nextItem = itemsToUpdate.FirstOrDefault();

                    if (nextItem is not null)
                    {
                        await UpdateTransportationDetailsAsync(prevItem, nextItem);
                        _unitOfWork.ItineraryItems.Update(nextItem);
                    }
                }

                // Readjust order index of remaining items
                foreach (var remainingItem in itemsToUpdate)
                {
                    remainingItem.OrderIndex--;
                }

                await _unitOfWork.SaveChangesAsync();
                await _unitOfWork.CommitTransactionAsync();
            }
            catch
            {
                await _unitOfWork.RollbackTransactionAsync();
                throw new BadHttpRequestException("Đã xảy ra lỗi khi cố gắng xóa mục khỏi các ngày");
            }
        }

        public async Task<ItineraryItemDto> UpdateItineraryItemAsync(int itemId, UpdateItineraryItemRequestDto request)
        {
            var item = await _unitOfWork.ItineraryItems.GetOneAsync(i => i.ItineraryItemId == itemId);

            if (item is null) throw new KeyNotFoundException($"Không tìm thấy mục lịch trình có ID {itemId}.");

            if (request.Note is not null)
            {
                item.Note = request.Note;
            }

            if (request.StartTime.HasValue && request.EndTime.HasValue)
            {
                if (request.EndTime <= request.StartTime)
                {
                    throw new ArgumentException("Thời gian kết thúc phải sau thời gian bắt đầu.");
                }
                item.StartTime = request.StartTime;
                item.EndTime = request.EndTime;
                var duration = request.EndTime - request.StartTime;
                item.EstimateDuration = duration.Value.TotalMinutes;
            }

            _unitOfWork.ItineraryItems.Update(item);

            await _unitOfWork.SaveChangesAsync();

            return _mapper.Map<ItineraryItemDto>(item);
        }

        public async Task<ItineraryItemDto> UpdateItineraryItemRouteInfoAsync(int itemId, UpdateItineraryItemRouteInfoRequestDto request)
        {
            if (!IsValidTravelMode(request.TravelMode))
            {
                throw new ArgumentException($"Chế độ di chuyển không hợp lệ: {request.TravelMode}");
            }

            var item = await _unitOfWork.ItineraryItems
                .GetOneAsync(i => i.ItineraryItemId == itemId, includeProperties: "Location,Location.Photos", tracked: true)
                ?? throw new KeyNotFoundException($"Không tìm thấy mục lịch trình có ID {itemId}.");

            var dayItems = await _unitOfWork.ItineraryItems.GetAllAsync(i => i.ItineraryDayId == item.ItineraryDayId,
                orderBy: q => q.OrderBy(i => i.OrderIndex));
            var prevItem = dayItems.FirstOrDefault(i => i.OrderIndex == item.OrderIndex - 1);

            if (prevItem is not null)
            {
                await UpdateTransportationDetailsAsync(prevItem, item, request.TravelMode);
                _unitOfWork.ItineraryItems.Update(item);
            }

            await _unitOfWork.SaveChangesAsync();
            return _mapper.Map<ItineraryItemDto>(item);
        }

        private async Task UpdateTransportationDetailsAsync(ItineraryItem prevItem, ItineraryItem curItem, string? travelMode = Constants.TravelMode_Driving)
        {
            var prevItemLocation = await _unitOfWork.Locations.GetOneAsync(l => l.Id == prevItem.LocationId);

            var curItemLocation = await _unitOfWork.Locations.GetOneAsync(l => l.Id == curItem.LocationId);

            var request = new ComputeRouteRequestDto
            {
                Origin = new OriginDestination
                {
                    PlaceId = prevItemLocation?.GooglePlaceId
                },
                Destination = new OriginDestination
                {
                    PlaceId = curItemLocation?.GooglePlaceId
                },
                TravelMode = travelMode ?? Constants.TravelMode_Driving,
            };

            var response = await _routeService.GetRouteInformationAsync(request);

            if (response is null || response.Routes is null || !response.Routes.Any()) throw new BadHttpRequestException("Không thể lấy thông tin tuyến đường.");

            curItem.TransportationDistance = response.Routes?.FirstOrDefault()?.DistanceMeters ?? 500;
            curItem.TransportationVehicle = travelMode ?? Constants.TravelMode_Driving;

            _ = double.TryParse(response.Routes?.FirstOrDefault()?.Duration.Replace("s", ""), out double durationInSeconds);

            curItem.TransportationDuration = durationInSeconds;
        }

        private bool IsValidTravelMode(string travelMode)
        {
            return travelMode == Constants.TravelMode_Driving ||
                   travelMode == Constants.TravelMode_Walking ||
                   travelMode == Constants.TravelMode_Bicycling ||
                   travelMode == Constants.TravelMode_Transit ||
                   travelMode == Constants.TravelMode_Two_Wheeler;
        }
    }
}

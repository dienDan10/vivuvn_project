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
    public class ItineraryRestaurantService(IUnitOfWork _unitOfWork, IGoogleMapPlaceService _placeService, IMapper _mapper, IJsonService _jsonService) : IitineraryRestaurantService
    {
        public async Task<IEnumerable<ItineraryRestaurantDto>> GetRestaurantsInItineraryAsync(int itineraryId)
        {
            return await _unitOfWork.ItineraryRestaurants
                 .GetQueryable()
                 .Where(ir => ir.ItineraryId == itineraryId)
                 .OrderBy(ir => ir.Date)
                     .ThenBy(ir => ir.Time)
                 .Select(ir => new ItineraryRestaurantDto
                 {
                     Id = ir.Id,
                     RestaurantId = ir.RestaurantId,
                     Cost = ir.BudgetItem != null ? ir.BudgetItem.Cost : 0,
                     Date = ir.Date ?? default,
                     Time = ir.Time ?? default,
                     Notes = ir.Notes,
                     Restaurant = ir.Restaurant != null ? new RestaurantDto
                     {
                         Id = ir.Restaurant.Id,
                         GooglePlaceId = ir.Restaurant.GooglePlaceId,
                         Name = ir.Restaurant.Name,
                         Address = ir.Restaurant.Address,
                         Rating = ir.Restaurant.Rating,
                         UserRatingCount = ir.Restaurant.UserRatingCount,
                         Latitude = ir.Restaurant.Latitude,
                         Longitude = ir.Restaurant.Longitude,
                         GoogleMapsUri = ir.Restaurant.GoogleMapsUri,
                         PriceLevel = ir.Restaurant.PriceLevel,
                         DeleteFlag = ir.Restaurant.DeleteFlag,
                         Photos = ir.Restaurant.Photos
                             .Select(p => p.PhotoUrl)
                             .ToList()
                     } : null
                 })
                 .AsNoTracking()
                 .ToListAsync();
        }

        public async Task AddRestaurantToItineraryFromSuggestionAsync(int itineraryId, AddRestaurantToItineraryFromSuggestionDto request)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new BadHttpRequestException("Không tìm thấy lịch trình");

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
                ?? throw new BadHttpRequestException("Không tìm thấy lịch trình");

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
                ?? throw new BadHttpRequestException("Không thể thêm nhà hàng. Không tìm thấy dữ liệu nhà hàng");

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
                ?? throw new BadHttpRequestException("Không tìm thấy nhà hàng trong lịch trình");
            itineraryRestaurant.Notes = notes;
            _unitOfWork.ItineraryRestaurants.Update(itineraryRestaurant);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task UpdateDateAsync(int itineraryId, int itineraryRestaurantId, DateOnly date)
        {
            var itineraryRestaurant = await _unitOfWork.ItineraryRestaurants
                .GetOneAsync(ir => ir.Id == itineraryRestaurantId && ir.ItineraryId == itineraryId)
                ?? throw new BadHttpRequestException("Không tìm thấy nhà hàng trong lịch trình");
            itineraryRestaurant.Date = date;
            _unitOfWork.ItineraryRestaurants.Update(itineraryRestaurant);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task UpdateTimeAsync(int itineraryId, int itineraryRestaurantId, TimeOnly time)
        {
            var itineraryRestaurant = await _unitOfWork.ItineraryRestaurants
                .GetOneAsync(ir => ir.Id == itineraryRestaurantId && ir.ItineraryId == itineraryId)
                ?? throw new BadHttpRequestException("Không tìm thấy nhà hàng trong lịch trình");
            itineraryRestaurant.Time = time;
            _unitOfWork.ItineraryRestaurants.Update(itineraryRestaurant);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task UpdateCostAsync(int itineraryId, int itineraryRestaurantId, decimal cost)
        {
            var itineraryRestaurant = await _unitOfWork.ItineraryRestaurants
                .GetOneAsync(ir => ir.Id == itineraryRestaurantId && ir.ItineraryId == itineraryId, includeProperties: "BudgetItem,Restaurant")
                ?? throw new BadHttpRequestException("Không tìm thấy nhà hàng trong lịch trình");

            // if budget item exists, update cost
            if (itineraryRestaurant.BudgetItem != null)
            {
                itineraryRestaurant.BudgetItem.Cost = cost;
                await _unitOfWork.Budgets.UpdateBudgetItemAsync(itineraryRestaurant.BudgetItem);
                await _unitOfWork.SaveChangesAsync();
                return;
            }

            // else, create new budget item
            var budget = await _unitOfWork.Budgets
                .GetOneAsync(b => b.ItineraryId == itineraryId)
                ?? throw new BadHttpRequestException("Không tìm thấy ngân sách cho lịch trình này");

            var budgetType = await _unitOfWork.BudgetTypes
                .GetOneAsync(bt => bt.Name == Constants.BudgetType_Food)
                ?? throw new BadHttpRequestException("Không tìm thấy loại ngân sách 'Ăn uống'");

            var budgetItem = new BudgetItem
            {
                Name = itineraryRestaurant.Restaurant?.Name ?? "Food cost",
                BudgetId = budget.BudgetId,
                Cost = cost,
                Date = itineraryRestaurant.Date.HasValue
                    ? itineraryRestaurant.Date.Value.ToDateTime(new TimeOnly(0, 0))
                    : DateTime.UtcNow,
                BudgetTypeId = budgetType.BudgetTypeId
            };
            await _unitOfWork.Budgets.AddBudgetItemAsync(budgetItem);
            await _unitOfWork.SaveChangesAsync();

            itineraryRestaurant.BudgetItemId = budgetItem.Id;
            _unitOfWork.ItineraryRestaurants.Update(itineraryRestaurant);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task DeleteItineraryRestaurantAsync(int itineraryId, int itineraryRestaurantId)
        {
            var itineraryRestaurant = await _unitOfWork.ItineraryRestaurants
                .GetOneAsync(ir => ir.Id == itineraryRestaurantId && ir.ItineraryId == itineraryId,
                             includeProperties: "BudgetItem")
                ?? throw new BadHttpRequestException("Không tìm thấy nhà hàng trong lịch trình");

            // Delete the related budget item if it exists
            if (itineraryRestaurant.BudgetItemId.HasValue)
            {
                await _unitOfWork.Budgets.DeleteBudgetItemAsync(itineraryRestaurant.BudgetItemId.Value);
            }

            // Delete the itinerary restaurant
            _unitOfWork.ItineraryRestaurants.Remove(itineraryRestaurant);
            await _unitOfWork.SaveChangesAsync();
        }

    }
}

using AutoMapper;
using LinqKit;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class LocationService(IMapper _mapper, IUnitOfWork _unitOfWork, IGoogleMapPlaceService _placeService, IJsonService _jsonService) : ILocationService
    {
        public async Task<IEnumerable<SearchLocationDto>> SearchLocationAsync(string? searchQuery,
            int? limit = Constants.DefaultPageSize)
        {
            if (string.IsNullOrEmpty(searchQuery))
            {
                return [];
            }

            var searchQueryNormalized = TextHelper.ToSearchFriendly(searchQuery);
            var locations = await _unitOfWork.Locations
                .GetAllAsync(l => l.NameNormalized.Contains(searchQueryNormalized), limit: limit);

            return _mapper.Map<IEnumerable<SearchLocationDto>>(locations);
        }

        public async Task<PaginatedResponseDto<LocationDto>> GetAllLocationsAsync(GetAllLocationsRequestDto requestDto)
        {
            // Build filter expression
            var predicate = PredicateBuilder.New<Location>(l => !l.DeleteFlag);

            if (!string.IsNullOrEmpty(requestDto.Name))
            {
                var searchQueryNormalized = TextHelper.ToSearchFriendly(requestDto.Name);
                predicate = predicate.And(l => l.NameNormalized.Contains(searchQueryNormalized));
            }

            if (requestDto.ProvinceId.HasValue)
            {
                predicate = predicate.And(l => l.ProvinceId == requestDto.ProvinceId.Value);
            }


            // Build order by expression
            Func<IQueryable<Location>, IOrderedQueryable<Location>>? orderBy = null;
            if (!string.IsNullOrEmpty(requestDto.SortBy))
            {
                orderBy = requestDto.SortBy.ToLower() switch
                {
                    "name" => q => requestDto.IsDescending ? q.OrderByDescending(l => l.NameNormalized) : q.OrderBy(l => l.NameNormalized),
                    "rating" => q => requestDto.IsDescending ? q.OrderByDescending(l => l.Rating) : q.OrderBy(l => l.Rating),
                    _ => q => q.OrderBy(l => l.NameNormalized)
                };
            }
            else
            {
                orderBy = q => q.OrderBy(l => l.NameNormalized);
            }

            // Get paginated data
            var (items, totalCount) = await _unitOfWork.Locations.GetPagedAsync(
                filter: predicate,
                orderBy: orderBy,
                pageNumber: requestDto.PageNumber,
                pageSize: requestDto.PageSize,
                includeProperties: "Photos,Province"
            );

            var locationDtos = _mapper.Map<IEnumerable<LocationDto>>(items);
            return new PaginatedResponseDto<LocationDto>
            {
                Data = locationDtos,
                PageNumber = requestDto.PageNumber,
                PageSize = requestDto.PageSize,
                TotalCount = totalCount,
                TotalPages = (int)Math.Ceiling(totalCount / (double)requestDto.PageSize),
                HasPreviousPage = requestDto.PageNumber > 1,
                HasNextPage = requestDto.PageNumber < (int)Math.Ceiling(totalCount / (double)requestDto.PageSize)
            };
        }

        public async Task<LocationDto> GetLocationByIdAsync(int id)
        {
            var location = await _unitOfWork.Locations.GetOneAsync(l => l.Id == id, includeProperties: "Photos");
            return _mapper.Map<LocationDto>(location);
        }

        public async Task<IEnumerable<RestaurantDto>> GetRestaurantsByLocationIdAsync(int locationId)
        {
            // Get location and validate
            var location = await _unitOfWork.Locations.GetOneAsync(l => l.Id == locationId, includeProperties: "NearbyRestaurants,NearbyRestaurants.Photos", tracked: true);
            if (location is null) throw new KeyNotFoundException("Location not found");
            if (!location.Latitude.HasValue || !location.Longitude.HasValue)
            {
                return [];
            }

            // return restaurants if db contains restaurants
            if (location.NearbyRestaurants is not null && location.NearbyRestaurants.Any())
            {
                return _mapper.Map<IEnumerable<RestaurantDto>>(location.NearbyRestaurants);
            }

            // Fetch nearby restaurants from Google Maps API
            var response = await _placeService.FetchNearbyRestaurantsAsync(location);

            if (response is null || response.Places is null || !response.Places.Any())
            {
                return [];
            }

            // Map Place objects to RestaurantDto using AutoMapper
            var restaurantDtos = _mapper.Map<IEnumerable<RestaurantDto>>(response.Places);

            // add restaurant to location's NearbyRestaurants and save to database
            var newRestaurants = _mapper.Map<IEnumerable<Restaurant>>(restaurantDtos);

            location.NearbyRestaurants = [.. newRestaurants];

            await _unitOfWork.SaveChangesAsync();

            // save restaurant to json file
            await _jsonService.SaveRestaurantsToJsonFile(location.GooglePlaceId ?? "", newRestaurants);

            return _mapper.Map<IEnumerable<RestaurantDto>>(newRestaurants);
        }

        public async Task<IEnumerable<HotelDto>> GetHotelsByLocationIdAsync(int locationId)
        {
            // Get location and validate
            var location = await _unitOfWork.Locations.GetOneAsync(l => l.Id == locationId, includeProperties: "NearbyHotels,NearbyHotels.Photos", tracked: true);
            if (location is null) throw new KeyNotFoundException("Location not found");
            if (!location.Latitude.HasValue || !location.Longitude.HasValue)
            {
                return [];
            }

            // return hotels if db contains hotels
            if (location.NearbyHotels is not null && location.NearbyHotels.Any())
            {
                return _mapper.Map<IEnumerable<HotelDto>>(location.NearbyHotels);
            }

            // Fetch nearby hotels from Google Maps API
            var response = await _placeService.FetchNearbyHotelsAsync(location);

            if (response is null || response.Places is null || !response.Places.Any())
            {
                return [];
            }

            // Map Place objects to HotelDto using AutoMapper
            var hotelDtos = _mapper.Map<IEnumerable<HotelDto>>(response.Places);

            // add hotel to location's NearbyHotels and save to database
            var newHotels = _mapper.Map<IEnumerable<Hotel>>(hotelDtos);

            location.NearbyHotels = [.. newHotels];

            await _unitOfWork.SaveChangesAsync();

            // save hotel to json file
            await _jsonService.SaveHotelsToJsonFile(location.GooglePlaceId ?? "", newHotels);

            return _mapper.Map<IEnumerable<HotelDto>>(newHotels);
        }

        public async Task<IEnumerable<SearchPlaceDto>> SearchRestaurantsByTextAsync(string textQuery, string? provinceName = null)
        {
            var response = await _placeService.SearchRestaurantsByTextAsync(textQuery, provinceName);
            if (response is null || !response.Places.Any()) return [];

            return _mapper.Map<IEnumerable<SearchPlaceDto>>(response.Places);
        }

        public async Task<IEnumerable<SearchPlaceDto>> SearchHotelsByTextAsync(string textQuery, string? provinceName = null)
        {
            var response = await _placeService.SearchHotelsByTextAsync(textQuery, provinceName);
            if (response is null || !response.Places.Any()) return [];
            return _mapper.Map<IEnumerable<SearchPlaceDto>>(response.Places);
        }

    }
}

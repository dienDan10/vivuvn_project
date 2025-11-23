using AutoMapper;
using System.Linq.Expressions;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
	public class LocationService(IMapper _mapper, IUnitOfWork _unitOfWork, IGoogleMapPlaceService _placeService, IJsonService _jsonService, IImageService _imageService, IAiClientService _aiService) : ILocationService
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
			Expression<Func<Location, bool>>? filter = null;

			if (!string.IsNullOrEmpty(requestDto.Name) || requestDto.ProvinceId.HasValue)
			{
				filter = l =>
					(string.IsNullOrEmpty(requestDto.Name) || l.NameNormalized.Contains(TextHelper.ToSearchFriendly(requestDto.Name))) &&
					(!requestDto.ProvinceId.HasValue || l.ProvinceId == requestDto.ProvinceId.Value);
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
				filter: filter,
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
			var location = await _unitOfWork.Locations.GetOneAsync(l => l.Id == id, includeProperties: "Photos,Province");
			return _mapper.Map<LocationDto>(location);
		}

		public async Task<IEnumerable<RestaurantDto>> GetRestaurantsByLocationIdAsync(int locationId)
		{
			// Get location and validate
			var location = await _unitOfWork.Locations.GetOneAsync(l => l.Id == locationId, includeProperties: "NearbyRestaurants,NearbyRestaurants.Photos", tracked: true);
			if (location is null) throw new KeyNotFoundException("Không tìm thấy địa điểm");
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
			if (location is null) throw new KeyNotFoundException("Không tìm thấy địa điểm");
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

		// CRUD Operations
		public async Task<LocationDto> CreateLocationAsync(CreateLocationRequestDto requestDto)
		{
			var existingLocation = await _unitOfWork.Locations.GetOneAsync(l =>
				l.Name == requestDto.Name &&
				l.ProvinceId == requestDto.ProvinceId &&
				!l.DeleteFlag
			);

			if (existingLocation != null)
			{
				throw new InvalidOperationException("Địa điểm với tên và tỉnh/thành phố đã tồn tại.");
			}

			var location = _mapper.Map<Location>(requestDto);

			// Handle multiple image uploads
			if (requestDto.Images != null && requestDto.Images.Any())
			{
				var photos = new List<vivuvn_api.Models.Photo>();
				foreach (var image in requestDto.Images)
				{
					var imageUrl = await _imageService.UploadImageAsync(image);
					photos.Add(new vivuvn_api.Models.Photo { PhotoUrl = imageUrl });
				}
				location.Photos = photos;
			}

			// Set NameNormalized for search
			location.NameNormalized = TextHelper.ToSearchFriendly(requestDto.Name);
			location.DeleteFlag = false;

			var province = await _unitOfWork.Provinces.GetOneAsync(p => p.Id == requestDto.ProvinceId);

			var placeData = string.IsNullOrEmpty(location.Address) ? await _placeService.FetchPlaceDetailsByTextAsync(location.Name, province.Name) : await _placeService.FetchPlaceDetailsByTextAsync(location.Name, province.Name, location.Address);

			var addressSplited = placeData.FormattedAddress.Split(',');

			var provinceNameFromPlace = addressSplited[addressSplited.Length - 2];

			if (provinceNameFromPlace != province.Name)
				throw new BadHttpRequestException("Địa điểm không thuộc tỉnh/thành phố đã chọn.");

			if (location.Address is null)
			{
				location.Address = placeData.FormattedAddress;
			}
			location.GooglePlaceId = placeData.PlaceId;
			location.Latitude = placeData.Latitude;
			location.Longitude = placeData.Longitude;
			location.ReviewUri = placeData.ReviewsUri;
			location.Rating = placeData.Rating;
			location.RatingCount = placeData.UserRatingCount;
			location.PlaceUri = placeData.GoogleMapsUri;

			PlaceUpsertRequestDto placeUpsert = _mapper.Map<PlaceUpsertRequestDto>(location);

			await _aiService.InsertPlaceAsync(placeUpsert);
			await _unitOfWork.Locations.AddAsync(location);
			await _unitOfWork.SaveChangesAsync();


			// Fetch the created location with its relationships
			var createdLocation = await _unitOfWork.Locations.GetOneAsync(
				l => l.Id == location.Id,
				includeProperties: "Photos,Province"
			);

			return _mapper.Map<LocationDto>(createdLocation);
		}

		public async Task<LocationDto> UpdateLocationAsync(int id, UpdateLocationRequestDto requestDto)
		{
			var location = await _unitOfWork.Locations.GetOneAsync(
				l => l.Id == id,
				includeProperties: "Photos",
				tracked: true
			);

			if (location == null)
			{
				throw new KeyNotFoundException($"Location with id {id} not found.");
			}

			// Map basic properties
			_mapper.Map(requestDto, location);

			// Update NameNormalized if name changed
			if (!string.IsNullOrEmpty(requestDto.Name))
			{
				location.NameNormalized = TextHelper.ToSearchFriendly(requestDto.Name);
			}

			// Handle image uploads (replace existing images if new images provided)
			if (requestDto.Images != null && requestDto.Images.Any())
			{
				// Clear existing photos
				location.Photos.Clear();

				// Upload new images
				var photos = new List<vivuvn_api.Models.Photo>();
				foreach (var image in requestDto.Images)
				{
					var imageUrl = await _imageService.UploadImageAsync(image);
					photos.Add(new vivuvn_api.Models.Photo { PhotoUrl = imageUrl });
				}
				location.Photos = photos;
			}

			var province = await _unitOfWork.Provinces.GetOneAsync(p => p.Id == requestDto.ProvinceId);

			var placeData = await _placeService.FetchPlaceDetailsByIdAsync(googlePlaceId: location.GooglePlaceId);

			var addressSplited = placeData.FormattedAddress.Split(',');

			var provinceNameFromPlace = addressSplited[addressSplited.Length - 2];

			if(provinceNameFromPlace != province.Name)
				throw new BadHttpRequestException("Địa điểm không thuộc tỉnh/thành phố đã chọn.");

			if (location.Address is null)
			{
				location.Address = placeData.FormattedAddress;
			}
			location.Province = province;
			location.GooglePlaceId = placeData.Id;
			location.Latitude = placeData.Location.Latitude;
			location.Longitude = placeData.Location.Longitude;
			location.ReviewUri = placeData.GoogleMapsLinks.ReviewsUri;
			location.Rating = placeData.Rating;
			location.RatingCount = placeData.UserRatingCount;
			location.PlaceUri = placeData.GoogleMapsUri;

			PlaceUpsertRequestDto placeUpsert = _mapper.Map<PlaceUpsertRequestDto>(location);

			await _aiService.UpdatePlaceAsync(placeUpsert);
			_unitOfWork.Locations.Update(location);
			await _unitOfWork.SaveChangesAsync();

			// Fetch updated location with relationships
			var updatedLocation = await _unitOfWork.Locations.GetOneAsync(
				l => l.Id == id,
				includeProperties: "Photos,Province"
			);

			return _mapper.Map<LocationDto>(updatedLocation);
		}

		public async Task DeleteLocationAsync(int id)
		{
			var location = await _unitOfWork.Locations.GetOneAsync(l => l.Id == id);

			if (location == null)
			{
				throw new KeyNotFoundException($"Không tìm thấy địa điểm với Id = {id}");
			}

			await _aiService.DeletePlaceAsync(location.GooglePlaceId);

			location.DeleteFlag = true;
			_unitOfWork.Locations.Update(location);
			await _unitOfWork.SaveChangesAsync();
		}

		public async Task<LocationDto> RestoreLocationAsync(int id)
		{
			var location = await _unitOfWork.Locations.GetOneAsync(
				l => l.Id == id,
				includeProperties: "Photos,Province"
			);

			if (location == null)
			{
				throw new KeyNotFoundException($"Không tìm thấy địa điểm với Id = {id}");
			}

            PlaceUpsertRequestDto placeUpsert = _mapper.Map<PlaceUpsertRequestDto>(location);
            await _aiService.InsertPlaceAsync(placeUpsert);

			location.DeleteFlag = false;
			_unitOfWork.Locations.Update(location);
			await _unitOfWork.SaveChangesAsync();

			return _mapper.Map<LocationDto>(location);
		}

	}
}

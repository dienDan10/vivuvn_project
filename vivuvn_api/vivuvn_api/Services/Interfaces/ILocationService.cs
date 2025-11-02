using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface ILocationService
    {
        Task<IEnumerable<SearchLocationDto>> SearchLocationAsync(string? searchQuery, int? limit);
        Task<PaginatedResponseDto<LocationDto>> GetAllLocationsAsync(GetAllLocationsRequestDto requestDto);
        Task<LocationDto> GetLocationByIdAsync(int id);
        Task<IEnumerable<RestaurantDto>> GetRestaurantsByLocationIdAsync(int locationId);
        Task<IEnumerable<HotelDto>> GetHotelsByLocationIdAsync(int locationId);
        Task<IEnumerable<SearchPlaceDto>> SearchRestaurantsByTextAsync(string textQuery, string? provinceName = null);
        Task<IEnumerable<SearchPlaceDto>> SearchHotelsByTextAsync(string textQuery, string? provinceName = null);
    }
}

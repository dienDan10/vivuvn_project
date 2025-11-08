using vivuvn_api.DTOs.Response;
using vivuvn_api.Models;

namespace vivuvn_api.Services.Interfaces
{
    public interface IGoogleMapPlaceService
    {
        Task<FetchGoogleRestaurantResponseDto?> FetchNearbyRestaurantsAsync(Location location);
        Task<FetchGoogleHotelResponseDto?> FetchNearbyHotelsAsync(Location location);
        Task<FetchGooglePlaceSimplifiedResponseDto?> SearchRestaurantsByTextAsync(string searchText, string? provinceName = null);
        Task<FetchGooglePlaceSimplifiedResponseDto?> SearchHotelsByTextAsync(string searchText, string? provinceName = null);
        Task<Place?> FetchPlaceDetailsByIdAsync(string googlePlaceId);
        Task<PlaceDetailDto?> FetchPlaceDetailsByTextAsync(string name, string provinceName, string? address = null);
        Task<string?> GetPhotoUrlAsync(string photoName, int? maxHeight = 400, int? maxWidth = 400);
    }
}

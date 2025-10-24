using vivuvn_api.DTOs.Response;
using vivuvn_api.Models;

namespace vivuvn_api.Services.Interfaces
{
    public interface IGoogleMapPlaceService
    {
        Task<FetchGoogleRestaurantResponseDto?> FetchNearbyRestaurantsAsync(Location location);
        Task<string?> GetPhotoUrlAsync(string photoName, int? maxHeight = 400, int? maxWidth = 400);
    }
}

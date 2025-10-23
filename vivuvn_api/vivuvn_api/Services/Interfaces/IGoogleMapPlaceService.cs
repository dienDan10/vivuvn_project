using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;

namespace vivuvn_api.Services.Interfaces
{
    public interface IGoogleMapPlaceService
    {
        Task<FetchGoogleRestaurantResponseDto?> FetchNearbyRestaurantsAsync(FetchGoogleRestaurantRequestDto request);
        Task<string?> GetPhotoUrlAsync(string photoName, int? maxHeight = 400, int? maxWidth = 400);
    }
}

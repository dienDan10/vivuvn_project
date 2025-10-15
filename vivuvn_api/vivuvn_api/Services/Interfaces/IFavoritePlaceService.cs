using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IFavoritePlaceService
    {
        Task AddFavoritePlaceAsync(int itineraryId, int locationId);
        Task RemoveFavoritePlaceAsync(int itineraryId, int locationId);
        Task<IEnumerable<FavoritePlaceDto>> GetFavoritePlacesByItineraryIdAsync(int itineraryId);
    }
}

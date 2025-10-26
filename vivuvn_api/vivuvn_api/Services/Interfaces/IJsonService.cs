using vivuvn_api.Models;

namespace vivuvn_api.Services.Interfaces
{
    public interface IJsonService
    {
        Task SaveHotelsToJsonFile(string locationPlaceId, IEnumerable<Hotel> hotels);
        Task SaveRestaurantsToJsonFile(string locationPlaceId, IEnumerable<Restaurant> restaurants);
        Task SaveSingleRestaurantToJsonFile(Restaurant restaurant);
        Task SaveSingleHotelToJsonFile(Hotel hotel);
    }
}

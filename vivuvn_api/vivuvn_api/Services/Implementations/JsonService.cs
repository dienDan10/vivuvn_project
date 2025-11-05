using System.Text.Json;
using vivuvn_api.Data.DbInitializer;
using vivuvn_api.Models;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class JsonService(IWebHostEnvironment _env) : IJsonService
    {
        public async Task SaveHotelsToJsonFile(string locationPlaceId, IEnumerable<Hotel> hotels)
        {
            var filePath = Path.Combine(_env.ContentRootPath, "Data", "hotel_data.json");

            // Read existing data from file
            List<HotelData> allHotelData = [];

            if (File.Exists(filePath))
            {
                var existingJson = await File.ReadAllTextAsync(filePath);
                if (!string.IsNullOrWhiteSpace(existingJson))
                {
                    allHotelData = JsonSerializer.Deserialize<List<HotelData>>(existingJson) ?? [];
                }
            }

            // Create new hotel data entry
            var hotelData = new HotelData
            {
                LocationGooglePlaceId = locationPlaceId,
                Hotels = hotels.Select(h => new HotelDataItem
                {
                    GooglePlaceId = h.GooglePlaceId ?? "",
                    Name = h.Name,
                    Address = h.Address,
                    Rating = h.Rating,
                    UserRatingCount = h.UserRatingCount,
                    Latitude = h.Latitude,
                    Longitude = h.Longitude,
                    GoogleMapsUri = h.GoogleMapsUri,
                    PriceLevel = h.PriceLevel,
                    Photos = h.Photos.Select(p => p.PhotoUrl).ToList()
                }).ToList()
            };

            // Remove existing entry for this location if it exists
            allHotelData.RemoveAll(rd => rd.LocationGooglePlaceId == locationPlaceId);

            // Add new entry
            allHotelData.Add(hotelData);

            // Write updated data back to file
            var json = JsonSerializer.Serialize(allHotelData, new JsonSerializerOptions { WriteIndented = true });
            await File.WriteAllTextAsync(filePath, json);
        }

        public async Task SaveRestaurantsToJsonFile(string locationPlaceId, IEnumerable<Restaurant> restaurants)
        {
            var filePath = Path.Combine(_env.ContentRootPath, "Data", "restaurant_data.json");

            // Read existing data from file
            List<RestaurantData> allRestaurantData = [];

            if (File.Exists(filePath))
            {
                var existingJson = await File.ReadAllTextAsync(filePath);
                if (!string.IsNullOrWhiteSpace(existingJson))
                {
                    allRestaurantData = JsonSerializer.Deserialize<List<RestaurantData>>(existingJson) ?? [];
                }
            }

            // Create new restaurant data entry
            var restaurantData = new RestaurantData
            {
                LocationGooglePlaceId = locationPlaceId,
                Restaurants = restaurants.Select(r => new RestaurantDataItem
                {
                    GooglePlaceId = r.GooglePlaceId ?? "",
                    Name = r.Name,
                    Address = r.Address,
                    Rating = r.Rating,
                    UserRatingCount = r.UserRatingCount,
                    Latitude = r.Latitude,
                    Longitude = r.Longitude,
                    GoogleMapsUri = r.GoogleMapsUri,
                    PriceLevel = r.PriceLevel,
                    Photos = r.Photos.Select(p => p.PhotoUrl).ToList()
                }).ToList()
            };

            // Remove existing entry for this location if it exists
            allRestaurantData.RemoveAll(rd => rd.LocationGooglePlaceId == locationPlaceId);

            // Add new entry
            allRestaurantData.Add(restaurantData);

            // Write updated data back to file
            var json = JsonSerializer.Serialize(allRestaurantData, new JsonSerializerOptions { WriteIndented = true });
            await File.WriteAllTextAsync(filePath, json);
        }

        public async Task SaveSingleRestaurantToJsonFile(Restaurant restaurant)
        {
            var filePath = Path.Combine(_env.ContentRootPath, "Data", "restaurants.json");
            List<RestaurantDataItem> allRestaurants = [];
            if (File.Exists(filePath))
            {
                var existingJson = await File.ReadAllTextAsync(filePath);
                if (!string.IsNullOrWhiteSpace(existingJson))
                {
                    allRestaurants = JsonSerializer.Deserialize<List<RestaurantDataItem>>(existingJson) ?? [];
                }
            }
            // Remove existing restaurant if it exists
            allRestaurants.RemoveAll(r => r.GooglePlaceId == restaurant.GooglePlaceId);
            // Add new restaurant
            var restaurantDataItem = new RestaurantDataItem
            {
                GooglePlaceId = restaurant.GooglePlaceId ?? "",
                Name = restaurant.Name,
                Address = restaurant.Address,
                Rating = restaurant.Rating,
                UserRatingCount = restaurant.UserRatingCount,
                Latitude = restaurant.Latitude,
                Longitude = restaurant.Longitude,
                GoogleMapsUri = restaurant.GoogleMapsUri,
                PriceLevel = restaurant.PriceLevel,
                Photos = restaurant.Photos.Select(p => p.PhotoUrl).ToList()
            };
            allRestaurants.Add(restaurantDataItem);
            // Write updated data back to file
            var json = JsonSerializer.Serialize(allRestaurants, new JsonSerializerOptions { WriteIndented = true });
            await File.WriteAllTextAsync(filePath, json);
        }

        public async Task SaveSingleHotelToJsonFile(Hotel hotel)
        {
            var filePath = Path.Combine(_env.ContentRootPath, "Data", "hotels.json");
            List<HotelDataItem> allHotels = [];
            if (File.Exists(filePath))
            {
                var existingJson = await File.ReadAllTextAsync(filePath);
                if (!string.IsNullOrWhiteSpace(existingJson))
                {
                    allHotels = JsonSerializer.Deserialize<List<HotelDataItem>>(existingJson) ?? [];
                }
            }

            // Remove existing hotel if it exists
            allHotels.RemoveAll(h => h.GooglePlaceId == hotel.GooglePlaceId);
            // Add new hotel
            var hotelDataItem = new HotelDataItem
            {
                GooglePlaceId = hotel.GooglePlaceId ?? "",
                Name = hotel.Name,
                Address = hotel.Address,
                Rating = hotel.Rating,
                UserRatingCount = hotel.UserRatingCount,
                Latitude = hotel.Latitude,
                Longitude = hotel.Longitude,
                GoogleMapsUri = hotel.GoogleMapsUri,
                PriceLevel = hotel.PriceLevel,
                Photos = hotel.Photos.Select(p => p.PhotoUrl).ToList()
            };
            allHotels.Add(hotelDataItem);
            // Write updated data back to file
            var json = JsonSerializer.Serialize(allHotels, new JsonSerializerOptions { WriteIndented = true });
            await File.WriteAllTextAsync(filePath, json);
        }
    }
}

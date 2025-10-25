using System.Text;
using System.Text.Json;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.Models;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class GoogleMapPlaceService(HttpClient _httpClient, IConfiguration _config) : IGoogleMapPlaceService
    {
        public async Task<FetchGoogleRestaurantResponseDto?> FetchNearbyRestaurantsAsync(Location location)
        {
            string apiKey = _config.GetValue<string>("GoogleMapService:ApiKey") ?? "";

            var request = new FetchGoogleRestaurantRequestDto
            {
                LocationRestriction = new LocationRestriction
                {
                    Circle = new Circle
                    {
                        Center = new LatLng
                        {
                            Latitude = location.Latitude.Value,
                            Longitude = location.Longitude.Value
                        }
                    }
                },
            };

            // Serialize with options to ignore null values
            var jsonOptions = new JsonSerializerOptions
            {
                DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull
            };

            var jsonBody = JsonSerializer.Serialize(request, jsonOptions);
            var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

            try
            {
                var requestMessage = new HttpRequestMessage(HttpMethod.Post, "./v1/places:searchNearby")
                {
                    Content = content
                };

                requestMessage.Headers.Add("X-Goog-Api-Key", apiKey);
                requestMessage.Headers.Add("X-Goog-FieldMask", "places.id,places.displayName,places.formattedAddress,places.rating,places.userRatingCount,places.location,places.googleMapsUri,places.priceLevel,places.photos");

                var response = await _httpClient.SendAsync(requestMessage);

                response.EnsureSuccessStatusCode();

                var responseContent = await response.Content.ReadFromJsonAsync<FetchGoogleRestaurantResponseDto>();

                // Fetch photo URLs for each place
                if (responseContent?.Places != null)
                {
                    await FetchPlacesPhotosAsync(responseContent.Places);
                }

                return responseContent;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public async Task<FetchGoogleHotelResponseDto?> FetchNearbyHotelsAsync(Location location)
        {
            string apiKey = _config.GetValue<string>("GoogleMapService:ApiKey") ?? "";

            var request = new FetchGoogleRestaurantRequestDto
            {
                IncludedTypes = new List<string> { "lodging" }, // Change to hotel/lodging type
                LocationRestriction = new LocationRestriction
                {
                    Circle = new Circle
                    {
                        Center = new LatLng
                        {
                            Latitude = location.Latitude.Value,
                            Longitude = location.Longitude.Value
                        }
                    }
                },
            };

            // Serialize with options to ignore null values
            var jsonOptions = new JsonSerializerOptions
            {
                DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull
            };

            var jsonBody = JsonSerializer.Serialize(request, jsonOptions);
            var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

            try
            {
                var requestMessage = new HttpRequestMessage(HttpMethod.Post, "./v1/places:searchNearby")
                {
                    Content = content
                };

                requestMessage.Headers.Add("X-Goog-Api-Key", apiKey);
                requestMessage.Headers.Add("X-Goog-FieldMask", "places.id,places.displayName,places.formattedAddress,places.rating,places.userRatingCount,places.location,places.googleMapsUri,places.priceLevel,places.photos");

                var response = await _httpClient.SendAsync(requestMessage);

                response.EnsureSuccessStatusCode();

                var responseContent = await response.Content.ReadFromJsonAsync<FetchGoogleHotelResponseDto>();

                // Fetch photo URLs for each place
                if (responseContent?.Places != null)
                {
                    await FetchPlacesPhotosAsync(responseContent.Places);
                }

                return responseContent;
            }
            catch (Exception)
            {
                return null;
            }
        }

        private async Task FetchPlacesPhotosAsync(IEnumerable<Place> places)
        {
            foreach (var place in places)
            {
                if (place.Photos != null && place.Photos.Any())
                {
                    var photoUrlTasks = place.Photos
                        .Take(3) // Limit to 3 photo to avoid too many requests
                        .Select(async photo =>
                        {
                            var photoUrl = await GetPhotoUrlAsync(photo.Name, 800, 800);
                            return photoUrl;
                        })
                        .ToList();

                    var photoUrls = await Task.WhenAll(photoUrlTasks);

                    // Replace photo names with actual URLs
                    place.Photos.Clear();
                    foreach (var photoUrl in photoUrls.Where(url => !string.IsNullOrEmpty(url)))
                    {
                        place.Photos.Add(new DTOs.Response.Photo { Name = photoUrl! });
                    }
                }
            }
        }

        public async Task<string?> GetPhotoUrlAsync(string photoName, int? maxHeight = 400, int? maxWidth = 400)
        {
            string apiKey = _config.GetValue<string>("GoogleMapService:ApiKey") ?? "";

            try
            {
                // Build query parameters
                var queryParams = new List<string>
                {
                    $"key={apiKey}"
                };

                if (maxHeight.HasValue)
                {
                    queryParams.Add($"maxHeightPx={maxHeight.Value}");
                }

                if (maxWidth.HasValue)
                {
                    queryParams.Add($"maxWidthPx={maxWidth.Value}");
                }

                var queryString = string.Join("&", queryParams);
                var requestUrl = $"./v1/{photoName}/media?{queryString}";

                var requestMessage = new HttpRequestMessage(HttpMethod.Get, requestUrl);
                requestMessage.Headers.Add("X-Goog-Api-Key", apiKey);

                var response = await _httpClient.SendAsync(requestMessage);

                if (response.IsSuccessStatusCode)
                {
                    // The response will be a redirect to the actual photo URL
                    // We can return the final URL after following redirects
                    return response.RequestMessage?.RequestUri?.ToString();
                }

                return null;
            }
            catch (Exception)
            {
                return null;
            }
        }
    }
}

using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;
using vivuvn_api.Helpers;
using vivuvn_api.Models;

namespace vivuvn_api.Data.DbInitializer
{
    public class DbInitializer(AppDbContext _context, IWebHostEnvironment _env) : IDbInitializer
    {
        public void Initialize()
        {
            // migration if they are not applied
            if (_context.Database.GetPendingMigrations().Any())
            {
                _context.Database.Migrate();
            }

            // create roles if they are not created
            InitializeRole();

            // Add a default admin user if not exists
            AddDefaultUser();

            // Add budget types
            AddBudgetType();

            // Add locations data
            AddLocationData();

            // Add restaurant data
            AddRestaurantData();

        }

        private void InitializeRole()
        {
            if (_context.Roles.Any()) return;

            _context.Roles.AddRange(
                new Role { Name = Constants.Role_Admin },
                new Role { Name = Constants.Role_Operator },
                new Role { Name = Constants.Role_Traveler });
            _context.SaveChanges();

        }

        private void AddDefaultUser()
        {
            if (_context.Users.Any(u => u.UserRoles.Any(ur => ur.Role.Name == Constants.Role_Admin))) return;

            var adminUser = new User
            {
                Email = "admin@gmail.com",
                Username = "Admin Desu!",
                IsEmailVerified = true,
                LockoutEnd = null,
                UserRoles = new List<UserRole>
                    {
                        new UserRole { RoleId = _context.Roles.Single(r => r.Name == Constants.Role_Admin).Id }
                    }
            };
            var hashedPassword = new PasswordHasher<User>().HashPassword(adminUser, "admin@123");
            adminUser.PasswordHash = hashedPassword;
            _context.Users.Add(adminUser);
            _context.SaveChanges();

        }

        private void AddBudgetType()
        {
            if (_context.BudgetTypes.Any()) return;

            var budgetTypes = new List<BudgetType>
                {
                    new BudgetType { Name = Constants.BudgetType_Flights },
                    new BudgetType { Name = Constants.BudgetType_Lodging },
                    new BudgetType { Name = Constants.BudgetType_CarRental },
                    new BudgetType { Name = Constants.BudgetType_Transit },
                    new BudgetType { Name = Constants.BudgetType_Food },
                    new BudgetType { Name = Constants.BudgetType_Drinks },
                    new BudgetType { Name = Constants.BudgetType_Sightseeing },
                    new BudgetType { Name = Constants.BudgetType_Activities },
                    new BudgetType { Name = Constants.BudgetType_Shopping },
                    new BudgetType { Name = Constants.BudgetType_Gas },
                    new BudgetType { Name = Constants.BudgetType_Groceries },
                    new BudgetType { Name = Constants.BudgetType_Other },
                };
            _context.BudgetTypes.AddRange(budgetTypes);
            _context.SaveChanges();

        }

        private void AddLocationData()
        {
            if (_context.Locations.Any()) return;

            var filePath = Path.Combine(_env.ContentRootPath, "Data", "location_data.json");

            if (!File.Exists(filePath))
            {
                return;
            }

            var json = File.ReadAllText(filePath);

            var options = new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true,
            };

            var provincesData = JsonSerializer.Deserialize<List<ProvinceData>>(json, options);

            if (provincesData == null || provincesData.Count == 0)
            {
                return;
            }

            // Add logic to save provincesData to the database
            foreach (var provinceData in provincesData)
            {
                // Save each provinceData to the database
                var province = new Province
                {
                    Name = provinceData.Province,
                    NameNormalized = TextHelper.ToSearchFriendly(provinceData.Province),
                    ImageUrl = provinceData.ImageUrl,
                };

                _context.Provinces.Add(province);
                _context.SaveChanges();

                foreach (var locationData in provinceData.Places)
                {
                    // Add each location to the database
                    var location = new Location
                    {
                        Name = locationData.Name,
                        NameNormalized = TextHelper.ToSearchFriendly(locationData.Name),
                        Description = locationData.Description,
                        Latitude = locationData.Latitude,
                        Longitude = locationData.Longitude,
                        Address = locationData.Address,
                        Rating = locationData.Rating,
                        RatingCount = locationData.UserRatingCount,
                        GooglePlaceId = locationData.GooglePlaceId,
                        PlaceUri = locationData.PlaceUri,
                        DirectionsUri = locationData.DirectionsUri,
                        ReviewUri = locationData.ReviewUri,
                        WebsiteUri = locationData.WebsiteUri,
                        DeleteFlag = false,
                        ProvinceId = province.Id,
                        Photos = new List<Photo>(),
                    };

                    if (locationData.Pictures != null && locationData.Pictures.Count > 0)
                    {
                        foreach (var pictureUrl in locationData.Pictures)
                        {
                            var photo = new Photo
                            {
                                PhotoUrl = pictureUrl,
                            };
                            location.Photos.Add(photo);
                        }
                    }

                    _context.Locations.Add(location);
                }
                _context.SaveChanges();
            }
        }

        private void AddRestaurantData()
        {
            var filePath = Path.Combine(_env.ContentRootPath, "Data", "restaurant_data.json");

            if (!File.Exists(filePath))
            {
                return;
            }

            var json = File.ReadAllText(filePath);

            var options = new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true,
            };

            var restaurantDataList = JsonSerializer.Deserialize<List<RestaurantData>>(json, options);

            if (restaurantDataList == null || restaurantDataList.Count == 0)
            {
                return;
            }

            foreach (var restaurantData in restaurantDataList)
            {
                // Find the location by GooglePlaceId
                var location = _context.Locations
                    .Include(l => l.NearbyRestaurants)
                    .FirstOrDefault(l => l.GooglePlaceId == restaurantData.LocationGooglePlaceId);

                if (location == null)
                {
                    continue; // Skip if location not found
                }

                // Check if location already has restaurants
                if (location.NearbyRestaurants != null && location.NearbyRestaurants.Any())
                {
                    continue; // Skip if restaurants already exist for this location
                }

                // Add restaurants to the location
                location.NearbyRestaurants = new List<Restaurant>();

                foreach (var restaurantItem in restaurantData.Restaurants)
                {
                    var restaurant = new Restaurant
                    {
                        GooglePlaceId = restaurantItem.GooglePlaceId,
                        Name = restaurantItem.Name,
                        Address = restaurantItem.Address,
                        Rating = restaurantItem.Rating,
                        UserRatingCount = restaurantItem.UserRatingCount,
                        Latitude = restaurantItem.Latitude,
                        Longitude = restaurantItem.Longitude,
                        GoogleMapsUri = restaurantItem.GoogleMapsUri,
                        PriceLevel = restaurantItem.PriceLevel,
                        Photos = new List<Photo>()
                    };

                    // Add photos if they exist
                    if (restaurantItem.Photos != null && restaurantItem.Photos.Count > 0)
                    {
                        foreach (var photoUrl in restaurantItem.Photos)
                        {
                            var photo = new Photo
                            {
                                PhotoUrl = photoUrl
                            };
                            restaurant.Photos.Add(photo);
                        }
                    }

                    location.NearbyRestaurants.Add(restaurant);
                }

                _context.SaveChanges();
            }
        }
    }
}

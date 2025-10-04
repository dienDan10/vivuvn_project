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
            if (!_context.Roles.Any())
            {
                _context.Roles.AddRange(
                    new Role { Name = Constants.Role_Admin },
                    new Role { Name = Constants.Role_Operator },
                    new Role { Name = Constants.Role_Traveler });
                _context.SaveChanges();
            }

            // Add a default admin user if not exists
            if (!_context.Users.Any(u => u.UserRoles.Any(ur => ur.Role.Name == Constants.Role_Admin)))
            {
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

            // Add locations data
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
                };

                _context.Provinces.Add(province);
                _context.SaveChanges();

                foreach (var locationData in provinceData.Places)
                {
                    // Add each location to the database
                    var location = new Location
                    {
                        Name = locationData.Name,
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
                    };

                    _context.Locations.Add(location);
                    _context.SaveChanges();

                    // Add Photos if any
                    if (locationData.Pictures != null && locationData.Pictures.Count > 0)
                    {
                        foreach (var pictureUrl in locationData.Pictures)
                        {
                            var photo = new Photo
                            {
                                PhotoUrl = pictureUrl,
                                DeleteFlag = false,
                            };
                            _context.Photos.Add(photo);
                            _context.SaveChanges();
                            var locationPhoto = new LocationPhoto
                            {
                                LocationId = location.Id,
                                PhotoId = photo.Id,
                            };
                            _context.LocationPhotos.Add(locationPhoto);
                            _context.SaveChanges();
                        }
                    }

                }
            }
        }
    }
}

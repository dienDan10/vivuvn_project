using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using vivuvn_api.Helpers;
using vivuvn_api.Models;

namespace vivuvn_api.Data.DbInitializer
{
    public class DbInitializer(AppDbContext dbcontext) : IDbInitializer
    {
        public void Initialize()
        {
            // migration if they are not applied
            if (dbcontext.Database.GetPendingMigrations().Any())
            {
                dbcontext.Database.Migrate();
            }

            // create roles if they are not created
            if (!dbcontext.Roles.Any())
            {
                dbcontext.Roles.AddRange(
                    new Role { Name = Constants.Role_Admin },
                    new Role { Name = Constants.Role_Operator },
                    new Role { Name = Constants.Role_Traveler });
                dbcontext.SaveChanges();
            }

            // Add a default admin user if not exists
            if (!dbcontext.Users.Any(u => u.UserRoles.Any(ur => ur.Role.Name == Constants.Role_Admin)))
            {
                var adminUser = new User
                {
                    Email = "admin@gmail.com",
                    Username = "Admin Desu!",
                    IsEmailVerified = true,
                    IsLock = false,
                    UserRoles = new List<UserRole>
                    {
                        new UserRole { RoleId = dbcontext.Roles.Single(r => r.Name == Constants.Role_Admin).Id }
                    }
                };
                var hashedPassword = new PasswordHasher<User>().HashPassword(adminUser, "admin@123");
                adminUser.PasswordHash = hashedPassword;
                dbcontext.Users.Add(adminUser);
                dbcontext.SaveChanges();
            }
        }
    }
}

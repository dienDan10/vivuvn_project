using Microsoft.EntityFrameworkCore;
using vivuvn_api.Models;

namespace vivuvn_api.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<UserRole> UserRoles { get; set; }
        public DbSet<PasswordReset> PasswordResets { get; set; }

        public DbSet<Province> Provinces { get; set; }
        public DbSet<Location> Locations { get; set; }

        public DbSet<Itinerary> Itineraries { get; set; }
        public DbSet<ItineraryDay> ItineraryDays { get; set; }
        public DbSet<ItineraryItem> ItineraryItems { get; set; }
        public DbSet<FavoritePlace> FavoritePlaces { get; set; }

        public DbSet<Budget> Budgets { get; set; }
        public DbSet<BudgetItem> BudgetItems { get; set; }
        public DbSet<BudgetType> BudgetTypes { get; set; }

        public DbSet<ExternalService> ExternalServices { get; set; }
        public DbSet<ServiceType> ServiceTypes { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Composite Keys
            modelBuilder.Entity<UserRole>()
                .HasKey(ur => new { ur.UserId, ur.RoleId });

            // Indexes
            modelBuilder.Entity<User>()
                .HasIndex(u => u.Email).IsUnique();

            modelBuilder.Entity<User>()
                .HasIndex(u => u.RefreshToken).IsUnique();

            modelBuilder.Entity<Itinerary>()
                .HasIndex(i => i.UserId);

            modelBuilder.Entity<ItineraryDay>()
                .HasIndex(d => d.ItineraryId);

            modelBuilder.Entity<ItineraryDay>()
                .HasIndex(d => new { d.ItineraryId, d.DayNumber });

            modelBuilder.Entity<ItineraryItem>()
                .HasIndex(ii => ii.ItineraryDayId);

            modelBuilder.Entity<ItineraryItem>()
                .HasIndex(ii => ii.LocationId);

            modelBuilder.Entity<Budget>()
                .HasIndex(b => b.ItineraryId);

            modelBuilder.Entity<BudgetItem>()
                .HasIndex(bi => bi.BudgetId);

            modelBuilder.Entity<BudgetItem>()
                .HasIndex(bi => bi.BudgetTypeId);

            modelBuilder.Entity<Location>()
                .HasIndex(l => l.ProvinceId);

            modelBuilder.Entity<Location>()
                .HasIndex(l => l.NameNormalized);

            modelBuilder.Entity<Location>()
                .HasIndex(l => l.GooglePlaceId);

            modelBuilder.Entity<Restaurant>()
                .HasIndex(r => r.GooglePlaceId);

            modelBuilder.Entity<Hotel>()
                .HasIndex(h => h.GooglePlaceId);

            modelBuilder.Entity<Province>()
                .HasIndex(p => p.NameNormalized)
                .IsUnique();

            modelBuilder.Entity<ExternalService>()
                .HasIndex(es => es.ItineraryDayId);

            modelBuilder.Entity<ExternalService>()
                .HasIndex(es => es.ServiceTypeId);

            // Relationship configurations
            modelBuilder.Entity<Itinerary>()
                .HasOne(i => i.StartProvince)
                .WithMany()
                .HasForeignKey(i => i.StartProvinceId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Itinerary>()
                .HasOne(i => i.DestinationProvince)
                .WithMany()
                .HasForeignKey(i => i.DestinationProvinceId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Photo>()
               .HasOne(p => p.Restaurant)
               .WithMany(r => r.Photos)
               .HasForeignKey(p => p.RestaurantId)
               .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Photo>()
                .HasOne(p => p.Location)
                .WithMany(l => l.Photos)
                .HasForeignKey(p => p.LocationId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Photo>()
                .HasOne(p => p.Hotel)
                .WithMany(h => h.Photos)
                .HasForeignKey(p => p.HotelId)
                .OnDelete(DeleteBehavior.Cascade);

            // Location - Hotel
            modelBuilder.Entity<Location>()
                .HasMany(l => l.NearbyHotels)
                .WithMany(h => h.NearbyLocations)
                .UsingEntity(j => j.ToTable("LocationHotel"));

            // Location - Restaurant
            modelBuilder.Entity<Location>()
                .HasMany(l => l.NearbyRestaurants)
                .WithMany(r => r.NearbyLocations)
                .UsingEntity(j => j.ToTable("LocationRestaurant"));
        }
    }
}

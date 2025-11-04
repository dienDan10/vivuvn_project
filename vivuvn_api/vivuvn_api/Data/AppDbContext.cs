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
        public DbSet<ItineraryHotel> ItineraryHotels { get; set; }
        public DbSet<ItineraryRestaurant> ItineraryRestaurants { get; set; }

        public DbSet<Photo> Photos { get; set; }
        public DbSet<Restaurant> Restaurants { get; set; }
        public DbSet<Hotel> Hotels { get; set; }


        public DbSet<Budget> Budgets { get; set; }
        public DbSet<BudgetItem> BudgetItems { get; set; }
        public DbSet<BudgetType> BudgetTypes { get; set; }

        public DbSet<ItineraryMember> ItineraryMembers { get; set; }
        public DbSet<ItineraryMessage> ItineraryMessages { get; set; }
        public DbSet<Notification> Notifications { get; set; }



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

            //Indexes for ItineraryHotel and ItineraryRestaurant
            modelBuilder.Entity<ItineraryHotel>()
                .HasIndex(ih => ih.ItineraryId);

            modelBuilder.Entity<ItineraryHotel>()
                .HasIndex(ih => ih.HotelId);

            modelBuilder.Entity<ItineraryHotel>()
                .HasIndex(ih => ih.BudgetItemId)
                .IsUnique();

            modelBuilder.Entity<ItineraryRestaurant>()
                .HasIndex(ir => ir.ItineraryId);

            modelBuilder.Entity<ItineraryRestaurant>()
                .HasIndex(ir => ir.RestaurantId);

            modelBuilder.Entity<ItineraryRestaurant>()
                .HasIndex(ir => ir.BudgetItemId)
                .IsUnique();
            // Indexes for ItineraryMember
            modelBuilder.Entity<ItineraryMember>()
                .HasIndex(im => im.ItineraryId);

            modelBuilder.Entity<ItineraryMember>()
                .HasIndex(im => im.UserId);

            modelBuilder.Entity<ItineraryMember>()
                .HasIndex(im => new { im.ItineraryId, im.UserId })
                .IsUnique();

            // Indexes for ItineraryMessage
            modelBuilder.Entity<ItineraryMessage>()
                .HasIndex(msg => msg.ItineraryId);

            modelBuilder.Entity<ItineraryMessage>()
                .HasIndex(msg => msg.ItineraryMemberId);

            modelBuilder.Entity<ItineraryMessage>()
                .HasIndex(msg => msg.CreatedAt);

            // Indexes for Notification
            modelBuilder.Entity<Notification>()
                .HasIndex(n => n.UserId);

            modelBuilder.Entity<Notification>()
                .HasIndex(n => n.ItineraryId);

            modelBuilder.Entity<Notification>()
                .HasIndex(n => n.IsRead);

            modelBuilder.Entity<Notification>()
                .HasIndex(n => n.CreatedAt);

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

            // ItineraryHotel - BudgetItem (One-to-One)
            modelBuilder.Entity<ItineraryHotel>()
                .HasOne(ih => ih.BudgetItem)
                .WithOne(bi => bi.ItineraryHotel)
                .HasForeignKey<ItineraryHotel>(ih => ih.BudgetItemId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<ItineraryHotel>()
                .HasOne(ih => ih.Itinerary)
                .WithMany(i => i.Hotels)
                .HasForeignKey(ih => ih.ItineraryId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<ItineraryHotel>()
                .HasOne(ih => ih.Hotel)
                .WithMany()
                .HasForeignKey(ih => ih.HotelId)
                .OnDelete(DeleteBehavior.Restrict); // Don't delete Hotel entity

            // ItineraryRestaurant - BudgetItem (One-to-One)
            modelBuilder.Entity<ItineraryRestaurant>()
                .HasOne(ir => ir.BudgetItem)
                .WithOne(bi => bi.ItineraryRestaurant)
                .HasForeignKey<ItineraryRestaurant>(ir => ir.BudgetItemId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<ItineraryRestaurant>()
                .HasOne(ir => ir.Itinerary)
                .WithMany(i => i.Restaurants)
                .HasForeignKey(ir => ir.ItineraryId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<ItineraryRestaurant>()
                .HasOne(ir => ir.Restaurant)
                .WithMany()
                .HasForeignKey(ir => ir.RestaurantId)
                .OnDelete(DeleteBehavior.Restrict); // Don't delete Restaurant entity

            // Relationship: ItineraryMember - Itinerary
            modelBuilder.Entity<ItineraryMember>()
                .HasOne(im => im.Itinerary)
                .WithMany(i => i.Members)
                .HasForeignKey(im => im.ItineraryId)
                .OnDelete(DeleteBehavior.Cascade);

            // Relationship: ItineraryMember - User
            modelBuilder.Entity<ItineraryMember>()
                .HasOne(im => im.User)
                .WithMany(u => u.ItineraryMemberships)
                .HasForeignKey(im => im.UserId)
                .OnDelete(DeleteBehavior.NoAction); // Avoid cascade conflicts with Itinerary->User

            // Relationship: ItineraryMessage - Itinerary
            modelBuilder.Entity<ItineraryMessage>()
                .HasOne(msg => msg.Itinerary)
                .WithMany(i => i.Messages)
                .HasForeignKey(msg => msg.ItineraryId)
                .OnDelete(DeleteBehavior.Cascade);

            // Relationship: ItineraryMessage - ItineraryMember
            modelBuilder.Entity<ItineraryMessage>()
                .HasOne(msg => msg.ItineraryMember)
                .WithMany()
                .HasForeignKey(msg => msg.ItineraryMemberId)
                .OnDelete(DeleteBehavior.NoAction); // Avoid cascade conflicts

            // Relationship: Notification - User
            modelBuilder.Entity<Notification>()
                .HasOne(n => n.User)
                .WithMany(u => u.Notifications)   // <- specify inverse navigation
                .HasForeignKey(n => n.UserId)
                .OnDelete(DeleteBehavior.NoAction);

            // Relationship: Notification - Itinerary
            modelBuilder.Entity<Notification>()
                .HasOne(n => n.Itinerary)
                .WithMany(i => i.Notifications)
                .HasForeignKey(n => n.ItineraryId)
                .OnDelete(DeleteBehavior.Cascade); // Avoid cascade conflicts with User

            // Index for Itinerary.InviteCode (unique, nullable)
            modelBuilder.Entity<Itinerary>()
                .HasIndex(i => i.InviteCode)
                .IsUnique();

            // BudgetItem - ItineraryMember (PaidByMember relationship)
            modelBuilder.Entity<BudgetItem>()
                .HasOne(bi => bi.PaidByMember)
                .WithMany()
                .HasForeignKey(bi => bi.PaidByMemberId)
                .OnDelete(DeleteBehavior.NoAction);

        }
    }
}

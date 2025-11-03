using Microsoft.EntityFrameworkCore.Storage;
using vivuvn_api.Data;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly AppDbContext _context;
        private IDbContextTransaction? _transaction;

        public IUserRepository Users { get; private set; }
        public IItineraryRepository Itineraries { get; private set; }
        public IItineraryDayRepository ItineraryDays { get; private set; }
        public IItineraryItemRepository ItineraryItems { get; private set; }
        public IBudgetRepository Budgets { get; private set; }
        public IProvinceRepository Provinces { get; private set; }
        public ILocationRepository Locations { get; private set; }
        public IFavoritePlaceRepository FavoritePlaces { get; private set; }
        public IItineraryRestaurantRepository ItineraryRestaurants { get; private set; }
        public IItineraryHotelRepository ItineraryHotels { get; private set; }
        public IRestaurantRepository Restaurants { get; private set; }
        public IHotelRepository Hotels { get; private set; }
        public IBudgetTypeRepository BudgetTypes { get; private set; }
        public IItineraryMemberRepository ItineraryMembers { get; private set; }
        public IItineraryMessageRepository ItineraryMessages { get; private set; }

        public UnitOfWork(AppDbContext context,
            IUserRepository userRepository,
            IItineraryRepository itineraryRepository,
            IItineraryDayRepository itineraryDayRepository,
            IBudgetRepository budgetRepository,
            IProvinceRepository provinceRepository,
            ILocationRepository locationRepository,
            IFavoritePlaceRepository favoritePlaceRepository,
            IItineraryItemRepository itineraryItem,
            IItineraryRestaurantRepository itineraryRestaurantRepository,
            IItineraryHotelRepository itineraryHotelRepository,
            IRestaurantRepository restaurantRepository,
            IHotelRepository hotelRepository,
            IBudgetTypeRepository budgetTypeRepository,
            IItineraryMemberRepository itineraryMemberRepository,
            IItineraryMessageRepository itineraryMessageRepository)
        {
            _context = context;
            Users = userRepository;
            Itineraries = itineraryRepository;
            ItineraryDays = itineraryDayRepository;
            Budgets = budgetRepository;
            Provinces = provinceRepository;
            Locations = locationRepository;
            FavoritePlaces = favoritePlaceRepository;
            ItineraryItems = itineraryItem;
            ItineraryRestaurants = itineraryRestaurantRepository;
            ItineraryHotels = itineraryHotelRepository;
            Restaurants = restaurantRepository;
            Hotels = hotelRepository;
            BudgetTypes = budgetTypeRepository;
            ItineraryMembers = itineraryMemberRepository;
            ItineraryMessages = itineraryMessageRepository;
        }

        public async Task SaveChangesAsync()
        {
            await _context.SaveChangesAsync();
        }

        public void Dispose()
        {
            _context.Dispose();
        }

        // Transaction Handling
        public async Task BeginTransactionAsync()
        {
            if (_transaction != null)
                return;

            _transaction = await _context.Database.BeginTransactionAsync();
        }

        public async Task CommitTransactionAsync()
        {
            try
            {
                if (_transaction != null)
                {
                    await _transaction.CommitAsync();
                }
            }
            catch
            {
                await RollbackTransactionAsync();
                throw new Exception("Error saving data to DB");
            }
            finally
            {
                if (_transaction != null)
                {
                    await _transaction.DisposeAsync();
                    _transaction = null;
                }
            }
        }

        public async Task RollbackTransactionAsync()
        {
            if (_transaction != null)
            {
                await _transaction.RollbackAsync();
                await _transaction.DisposeAsync();
                _transaction = null;
            }
        }
    }
}

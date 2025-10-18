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
        public IItineraryDayRepository ItineraryDays { get; set; }
        public IItineraryItemRepository ItineraryItems { get; set; }
        public IBudgetRepository Budgets { get; set; }
        public IBudgetItemRepository BudgetItems { get; private set; }
        public IBudgetTypeRepository BudgetTypes { get; private set; }
        public IProvinceRepository Provinces { get; set; }
        public ILocationRepository Locations { get; private set; }
        public IFavoritePlaceRepository FavoritePlaces { get; private set; }

        public UnitOfWork(AppDbContext context,
            IUserRepository userRepository,
            IItineraryRepository itineraryRepository,
            IItineraryDayRepository itineraryDayRepository,
            IBudgetRepository budgetRepository,
            IBudgetItemRepository budgetItemRepository,
            IBudgetTypeRepository budgetTypeRepository,
            IProvinceRepository provinceRepository,
            ILocationRepository locationRepository,
            IFavoritePlaceRepository favoritePlaceRepository,
            IItineraryItemRepository itineraryItem)
        {
            _context = context;
            Users = userRepository;
            Itineraries = itineraryRepository;
            ItineraryDays = itineraryDayRepository;
            Budgets = budgetRepository;
            BudgetItems = budgetItemRepository;
            BudgetTypes = budgetTypeRepository;
            Provinces = provinceRepository;
            Locations = locationRepository;
            FavoritePlaces = favoritePlaceRepository;
            ItineraryItems = itineraryItem;
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
                await _context.SaveChangesAsync();
                await _transaction?.CommitAsync()!;
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

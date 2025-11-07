namespace vivuvn_api.Repositories.Interfaces
{
    public interface IUnitOfWork : IDisposable
    {
        IUserRepository Users { get; }
        IRoleRepository Roles { get; }
        IItineraryRepository Itineraries { get; }
        IItineraryDayRepository ItineraryDays { get; }
        IItineraryItemRepository ItineraryItems { get; }
        IBudgetRepository Budgets { get; }
        IProvinceRepository Provinces { get; }
        ILocationRepository Locations { get; }
        IFavoritePlaceRepository FavoritePlaces { get; }
        IItineraryHotelRepository ItineraryHotels { get; }
        IItineraryRestaurantRepository ItineraryRestaurants { get; }
        IHotelRepository Hotels { get; }
        IRestaurantRepository Restaurants { get; }
        IBudgetTypeRepository BudgetTypes { get; }
        IItineraryMemberRepository ItineraryMembers { get; }
        IItineraryMessageRepository ItineraryMessages { get; }
        IUserDeviceRepository UserDevices { get; }
        INotificationRepository Notifications { get; }

        Task SaveChangesAsync();

        // Transaction support
        Task BeginTransactionAsync();
        Task CommitTransactionAsync();
        Task RollbackTransactionAsync();
    }
}

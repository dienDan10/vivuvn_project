namespace vivuvn_api.Repositories.Interfaces
{
    public interface IUnitOfWork : IDisposable
    {
        IUserRepository Users { get; }
        IItineraryRepository Itineraries { get; }
        IItineraryDayRepository ItineraryDays { get; }
        IBudgetRepository Budgets { get; }
        IProvinceRepository Provinces { get; }

        Task SaveChangesAsync();

        // Transaction support
        Task BeginTransactionAsync();
        Task CommitTransactionAsync();
        Task RollbackTransactionAsync();
    }
}

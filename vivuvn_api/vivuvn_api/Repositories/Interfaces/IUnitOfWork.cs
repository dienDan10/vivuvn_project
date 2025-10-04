namespace vivuvn_api.Repositories.Interfaces
{
    public interface IUnitOfWork
    {
        IUserRepository UserRepository { get; }

        Task SaveAsync();
    }
}

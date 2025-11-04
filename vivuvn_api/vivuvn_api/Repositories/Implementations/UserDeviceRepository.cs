using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class UserDeviceRepository : Repository<UserDevice>, IUserDeviceRepository
    {
        public UserDeviceRepository(AppDbContext context) : base(context)
        {
        }
    }

}

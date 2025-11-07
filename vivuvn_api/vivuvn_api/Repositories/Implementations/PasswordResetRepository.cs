using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class PasswordResetRepository : Repository<PasswordReset>, IPasswordResetRepository
    {
        public PasswordResetRepository(AppDbContext context) : base(context)
        {
        }
    }
}

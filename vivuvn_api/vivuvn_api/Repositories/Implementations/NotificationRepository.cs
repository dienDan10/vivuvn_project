using Microsoft.EntityFrameworkCore;
using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class NotificationRepository : Repository<Notification>, INotificationRepository
    {
        public NotificationRepository(AppDbContext context) : base(context)
        {
        }

        public async Task<int> GetUnreadCountAsync(int userId)
        {
            var count = await _context.Notifications.CountAsync(n => n.UserId == userId && !n.IsRead && !n.DeleteFlag);

            return count;
        }
    }
}

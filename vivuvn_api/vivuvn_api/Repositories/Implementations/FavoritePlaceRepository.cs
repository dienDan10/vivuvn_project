using vivuvn_api.Data;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;

namespace vivuvn_api.Repositories.Implementations
{
    public class FavoritePlaceRepository : Repository<FavoritePlace>, IFavoritePlaceRepository
    {
        public FavoritePlaceRepository(AppDbContext context) : base(context)
        {
        }
    }
}

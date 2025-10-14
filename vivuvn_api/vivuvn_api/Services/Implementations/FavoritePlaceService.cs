using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class FavoritePlaceService(IUnitOfWork _unitOfWork) : IFavoritePlaceService
    {
        public async Task AddFavoritePlaceAsync(int itineraryId, int locationId)
        {
            var favoritePlace = new FavoritePlace
            {
                ItineraryId = itineraryId,
                LocationId = locationId
            };

            await _unitOfWork.FavoritePlaces.AddAsync(favoritePlace);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task RemoveFavoritePlaceAsync(int itineraryId, int locationId)
        {
            var favoritePlace = await _unitOfWork.FavoritePlaces
                .GetOneAsync(fp => fp.ItineraryId == itineraryId && fp.LocationId == locationId);

            if (favoritePlace is null)
            {
                throw new KeyNotFoundException("Favorite place not found.");
            }

            _unitOfWork.FavoritePlaces.Remove(favoritePlace);
            await _unitOfWork.SaveChangesAsync();
        }
    }
}

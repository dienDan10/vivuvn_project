using AutoMapper;
using Microsoft.EntityFrameworkCore;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class FavoritePlaceService(IUnitOfWork _unitOfWork, IMapper _mapper) : IFavoritePlaceService
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
                throw new KeyNotFoundException("Không tìm thấy địa điểm yêu thích.");
            }

            _unitOfWork.FavoritePlaces.Remove(favoritePlace);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task<IEnumerable<FavoritePlaceDto>> GetFavoritePlacesByItineraryIdAsync(int itineraryId)
        {
            var favoritePlaces = await _unitOfWork.FavoritePlaces
                .GetQueryable()
                .Where(fp => fp.ItineraryId == itineraryId)
                .Include(fp => fp.Location)
                    .ThenInclude(l => l.Photos)
                .Include(fp => fp.Location)
                    .ThenInclude(l => l.Province)
                .AsSplitQuery()
                .AsNoTracking()
                .ToListAsync();
            return _mapper.Map<IEnumerable<FavoritePlaceDto>>(favoritePlaces);
        }
    }
}

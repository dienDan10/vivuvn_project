using AutoMapper;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Helpers;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class LocationService(IMapper _mapper, IUnitOfWork _unitOfWork) : ILocationService
    {
        public async Task<IEnumerable<SearchLocationDto>> SearchLocationAsync(string? searchQuery, int? limit = 10)
        {
            if (string.IsNullOrEmpty(searchQuery))
            {
                return [];
            }

            var searchQueryNormalized = TextHelper.ToSearchFriendly(searchQuery);
            var locations = await _unitOfWork.Locations
                .SearchLocationsAsync(l => l.NameNormalized.Contains(searchQueryNormalized), limit: limit);

            return _mapper.Map<IEnumerable<SearchLocationDto>>(locations);
        }

        public async Task<LocationDto> GetLocationByIdAsync(int id)
        {
            var location = await _unitOfWork.Locations.GetOneAsync(l => l.Id == id, includeProperties: "LocationPhotos");
            return _mapper.Map<LocationDto>(location);
        }
    }
}

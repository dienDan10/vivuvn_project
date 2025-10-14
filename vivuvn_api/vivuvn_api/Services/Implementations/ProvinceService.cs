using AutoMapper;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Helpers;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ProvinceService(IMapper _mapper, IUnitOfWork _unitOfWork) : IProvinceService
    {
        public async Task<IEnumerable<ProvinceDto>> SearchProvinceAsync(string? queryString, int? limit = 10)
        {
            if (string.IsNullOrWhiteSpace(queryString))
            {
                return [];
            }

            var normalizedQuery = TextHelper.ToSearchFriendly(queryString);
            var provinces = await _unitOfWork.Provinces
                .SearchProvincesAsync(p => p.NameNormalized.Contains(normalizedQuery), limit: limit);

            return _mapper.Map<IEnumerable<ProvinceDto>>(provinces);
        }
    }
}

using AutoMapper;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ProvinceService(IMapper _mapper, IUnitOfWork _unitOfWork) : IProvinceService
    {
        public async Task<IEnumerable<ProvinceDto>> SearchProvinceAsync(string queryString)
        {
            var provinces = await _unitOfWork.Provinces
                .GetAllAsync(p => p.Name.ToLower().Contains(queryString.ToLower()));

            return _mapper.Map<IEnumerable<ProvinceDto>>(provinces);
        }
    }
}

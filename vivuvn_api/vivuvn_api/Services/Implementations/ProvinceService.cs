using AutoMapper;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Helpers;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ProvinceService(IMapper _mapper, IUnitOfWork _unitOfWork) : IProvinceService
    {
		public async Task<IEnumerable<ProvinceDto>> GetAllProvincesAsync()
		{
            var provinces = await _unitOfWork.Provinces.GetAllAsync();
            return _mapper.Map<IEnumerable<ProvinceDto>>(provinces);
		}

		public async Task<ProvinceDto> RestoreProvince(int id)
		{
            var province = await  _unitOfWork.Provinces.GetOneAsync(p => p.Id == id);

            if (province == null)
            {
                throw new KeyNotFoundException($"Province with id {id} not found.");
			}

            province.DeleteFlag = false;
            _unitOfWork.Provinces.Update(province);
            await _unitOfWork.SaveChangesAsync();
            return _mapper.Map<ProvinceDto>(province);
		}

		public async Task DeleteProvince(int id)
		{
			var province = await _unitOfWork.Provinces.GetOneAsync(p => p.Id == id);

			if (province == null)
			{
				throw new KeyNotFoundException($"Province with id {id} not found.");
			}

			province.DeleteFlag = true;
			_unitOfWork.Provinces.Update(province);
			await _unitOfWork.SaveChangesAsync();
		}

		public async Task<IEnumerable<ProvinceDto>> SearchProvinceAsync(string? queryString, int? limit = 10)
        {
            if (string.IsNullOrWhiteSpace(queryString))
            {
                return [];
            }

            var normalizedQuery = TextHelper.ToSearchFriendly(queryString);
            var provinces = await _unitOfWork.Provinces
                .SearchProvincesAsync(p => p.NameNormalized.Contains(normalizedQuery) && !p.DeleteFlag, limit: limit);

            return _mapper.Map<IEnumerable<ProvinceDto>>(provinces);
        }
    }
}

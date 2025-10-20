using AutoMapper;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
	public class ProvinceService(IMapper _mapper, IUnitOfWork _unitOfWork, IImageService _imageService) : IProvinceService
	{
		public async Task<IEnumerable<ProvinceDto>> GetAllProvincesAsync()
		{
			var provinces = await _unitOfWork.Provinces.GetAllAsync();
			return _mapper.Map<IEnumerable<ProvinceDto>>(provinces);
		}

		public async Task<ProvinceDto> RestoreProvinceAsync(int id)
		{
			var province = await _unitOfWork.Provinces.GetOneAsync(p => p.Id == id);

			if (province == null)
			{
				throw new KeyNotFoundException($"Province with id {id} not found.");
			}

			province.DeleteFlag = false;
			_unitOfWork.Provinces.Update(province);
			await _unitOfWork.SaveChangesAsync();
			return _mapper.Map<ProvinceDto>(province);
		}

		public async Task DeleteProvinceAsync(int id)
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

		public async Task<ProvinceDto> GetProvinceByIdAsync(int id)
		{
			var province = await _unitOfWork.Provinces.GetOneAsync(p => p.Id == id && !p.DeleteFlag);

			if (province == null)
			{
				throw new KeyNotFoundException($"Province with id {id} not found.");
			}

			return _mapper.Map<ProvinceDto>(province);
		}

		public async Task<ProvinceDto> CreateProvinceAsync(CreateProvinceRequestDto requestDto)
		{
			var province = _mapper.Map<Province>(requestDto);

			// Handle image upload
			if (requestDto.Image != null)
			{
				var imageUrl = await _imageService.UploadImageAsync(requestDto.Image);
				province.ImageUrl = imageUrl;
			}
			else
			{
				province.ImageUrl = null;
			}

			await _unitOfWork.Provinces.AddAsync(province);
			await _unitOfWork.SaveChangesAsync();
			return _mapper.Map<ProvinceDto>(province);
		}

		public async Task<ProvinceDto> UpdateProvinceAsync(int id, UpdateProvinceRequestDto requestDto)
		{
			var province = await _unitOfWork.Provinces.GetOneAsync(p => p.Id == id);

			if (province == null)
			{
				throw new KeyNotFoundException($"Province with id {id} not found.");
			}

			_mapper.Map(requestDto, province);

			// Handle image upload
			if (requestDto.Image != null)
			{
				var imageUrl = await _imageService.UploadImageAsync(requestDto.Image);
				province.ImageUrl = imageUrl;
			}

			_unitOfWork.Provinces.Update(province);
			await _unitOfWork.SaveChangesAsync();

			return _mapper.Map<ProvinceDto>(province);
		}
	}
}

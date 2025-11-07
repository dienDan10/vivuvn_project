using AutoMapper;
using System.Linq.Expressions;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
	public class ProvinceService(IMapper _mapper, IUnitOfWork _unitOfWork, IImageService _imageService) : IProvinceService
	{
		public async Task<IEnumerable<ProvinceDto>> GetAllProvincesWithoutPaginationAsync()
		{
			var provinces = await _unitOfWork.Provinces.GetAllAsync(
				filter: p => !p.DeleteFlag,
				orderBy: q => q.OrderBy(p => p.Name)
			);

			return _mapper.Map<IEnumerable<ProvinceDto>>(provinces);
		}

		public async Task<PaginatedResponseDto<ProvinceDto>> GetAllProvincesAsync(GetAllProvincesRequestDto requestDto)
		{
			// Build filter expression
			Expression<Func<Province, bool>>? filter = null;

			if (!string.IsNullOrEmpty(requestDto.Name) || !string.IsNullOrEmpty(requestDto.ProvinceCode))
			{
				filter = p =>
					(string.IsNullOrEmpty(requestDto.Name) || p.NameNormalized.Contains(TextHelper.ToSearchFriendly(requestDto.Name))) &&
					(string.IsNullOrEmpty(requestDto.ProvinceCode) || p.ProvinceCode == requestDto.ProvinceCode);
			}

			// Build orderBy function
			Func<IQueryable<Province>, IOrderedQueryable<Province>>? orderBy = null;

			if (!string.IsNullOrEmpty(requestDto.SortBy))
			{
				orderBy = requestDto.SortBy.ToLower() switch
				{
					"name" => q => requestDto.IsDescending ? q.OrderByDescending(p => p.NameNormalized) : q.OrderBy(p => p.NameNormalized),
					"provinceCode" => q => requestDto.IsDescending ? q.OrderByDescending(p => p.ProvinceCode) : q.OrderBy(p => p.ProvinceCode),
					"id" => q => requestDto.IsDescending ? q.OrderByDescending(p => p.Id) : q.OrderBy(p => p.Id),
					_ => q => q.OrderBy(p => p.Id)
				};
			}
			else
			{
				orderBy = q => q.OrderBy(p => p.NameNormalized);
			}

			// Get paginated data
			var (items, totalCount) = await _unitOfWork.Provinces.GetPagedAsync(
				filter: filter,
				orderBy: orderBy,
				pageNumber: requestDto.PageNumber,
				pageSize: requestDto.PageSize
			);

			var provinceDtos = _mapper.Map<IEnumerable<ProvinceDto>>(items);

			return new PaginatedResponseDto<ProvinceDto>
			{
				Data = provinceDtos,
				PageNumber = requestDto.PageNumber,
				PageSize = requestDto.PageSize,
				TotalCount = totalCount,
				TotalPages = (int)Math.Ceiling(totalCount / (double)requestDto.PageSize),
				HasPreviousPage = requestDto.PageNumber > 1,
				HasNextPage = requestDto.PageNumber < (int)Math.Ceiling(totalCount / (double)requestDto.PageSize)
			};
		}

		public async Task<ProvinceDto> RestoreProvinceAsync(int id)
		{
			var province = await _unitOfWork.Provinces.GetOneAsync(p => p.Id == id);

			if (province == null)
			{
				throw new KeyNotFoundException($"Không tìm thấy tỉnh/thành phố có ID {id}.");
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
				throw new KeyNotFoundException($"Không tìm thấy tỉnh/thành phố có ID {id}.");
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
				throw new KeyNotFoundException($"Không tìm thấy tỉnh/thành phố có ID {id}.");
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
				throw new KeyNotFoundException($"Không tìm thấy tỉnh/thành phố có ID {id}.");
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

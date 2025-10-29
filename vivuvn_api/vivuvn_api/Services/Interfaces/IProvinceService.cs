using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IProvinceService
    {
		Task<ProvinceDto> CreateProvinceAsync(CreateProvinceRequestDto requestDto);
		Task DeleteProvinceAsync(int id);
		Task<PaginatedResponseDto<ProvinceDto>> GetAllProvincesAsync(GetAllProvincesRequestDto requestDto);
		Task<ProvinceDto> GetProvinceByIdAsync(int id);
		Task<ProvinceDto> RestoreProvinceAsync(int id);
		Task<IEnumerable<ProvinceDto>> SearchProvinceAsync(string? queryString, int? limit);
		Task<ProvinceDto> UpdateProvinceAsync(int id, UpdateProvinceRequestDto requestDto);
	}
}

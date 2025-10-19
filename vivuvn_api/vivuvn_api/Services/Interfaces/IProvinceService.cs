using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IProvinceService
    {
		Task DeleteProvince(int id);
		Task<IEnumerable<ProvinceDto>> GetAllProvincesAsync();
		Task<ProvinceDto> RestoreProvince(int id);
		Task<IEnumerable<ProvinceDto>> SearchProvinceAsync(string? queryString, int? limit);
    }
}

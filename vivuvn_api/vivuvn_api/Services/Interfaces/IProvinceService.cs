using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IProvinceService
    {
        Task<IEnumerable<ProvinceDto>> SearchProvinceAsync(string? queryString, int? limit);
    }
}

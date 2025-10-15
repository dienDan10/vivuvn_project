using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface ILocationService
    {
        Task<IEnumerable<SearchLocationDto>> SearchLocationAsync(string? searchQuery, int? limit);
        Task<LocationDto> GetLocationByIdAsync(int id);
    }
}

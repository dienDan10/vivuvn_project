using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface ILocationService
    {
        Task<IEnumerable<SearchLocationDto>> SearchLocationAsync(string? searchQuery, int? limit);
        Task<PaginatedResponseDto<LocationDto>> GetAllLocationsAsync(GetAllLocationsRequestDto requestDto);
        Task<LocationDto> GetLocationByIdAsync(int id);
    }
}

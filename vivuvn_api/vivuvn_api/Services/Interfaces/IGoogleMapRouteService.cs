using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;

namespace vivuvn_api.Services.Interfaces
{
    public interface IGoogleMapRouteService
    {
        Task<GetRouteInfoResponseDto?> GetRouteInformationAsync(ComputeRouteRequestDto request);
    }
}

using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;

namespace vivuvn_api.Services.Interfaces
{
    public interface IAnalyticsService
    {
        Task<DashboardOverviewDto> GetDashboardOverviewAsync(GetAnalyticsRequestDto requestDto);
        Task<IEnumerable<TopProvinceDto>> GetTopProvincesAsync(GetAnalyticsRequestDto requestDto);
        Task<IEnumerable<TopLocationDto>> GetTopLocationsAsync(GetAnalyticsRequestDto requestDto);
        Task<IEnumerable<ItineraryTrendDto>> GetItineraryTrendsAsync(GetAnalyticsRequestDto requestDto);
    }
}

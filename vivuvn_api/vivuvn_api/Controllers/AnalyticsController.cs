using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Helpers;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/analytics")]
    [ApiController]
    [Authorize(Roles = $"{Constants.Role_Admin},{Constants.Role_Operator}")]
    public class AnalyticsController(IAnalyticsService _analyticsService) : ControllerBase
    {
        [HttpGet("overview")]
        public async Task<IActionResult> GetDashboardOverview([FromQuery] GetAnalyticsRequestDto requestDto)
        {
            var overview = await _analyticsService.GetDashboardOverviewAsync(requestDto);
            return Ok(overview);
        }

        [HttpGet("provinces/top")]
        public async Task<IActionResult> GetTopProvinces([FromQuery] GetAnalyticsRequestDto requestDto)
        {
            var topProvinces = await _analyticsService.GetTopProvincesAsync(requestDto);
            return Ok(topProvinces);
        }

        [HttpGet("locations/top")]
        public async Task<IActionResult> GetTopLocations([FromQuery] GetAnalyticsRequestDto requestDto)
        {
            var topLocations = await _analyticsService.GetTopLocationsAsync(requestDto);
            return Ok(topLocations);
        }

        [HttpGet("itineraries/trends")]
        public async Task<IActionResult> GetItineraryTrends([FromQuery] GetAnalyticsRequestDto requestDto)
        {
            var trends = await _analyticsService.GetItineraryTrendsAsync(requestDto);
            return Ok(trends);
        }
    }
}

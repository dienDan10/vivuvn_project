using Microsoft.AspNetCore.Mvc;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/locations")]
    [ApiController]
    public class LocationController(ILocationService _locationService) : ControllerBase
    {
        [HttpGet("search")]
        public async Task<IActionResult> SearchLocation([FromQuery] SearchLocationRequestDto request)
        {
            var locations = await _locationService.SearchLocationAsync(request.Name!, request.Limit);
            return Ok(locations);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetLocationById(int id)
        {
            var locations = await _locationService.GetLocationByIdAsync(id);

            if (locations is null)
            {
                return NotFound("Location not found");
            }

            return Ok(locations);
        }
    }
}

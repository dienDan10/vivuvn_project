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

        [HttpGet]
        public async Task<IActionResult> GetAllLocations([FromQuery] GetAllLocationsRequestDto request)
        {
            var locations = await _locationService.GetAllLocationsAsync(request);
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

        [HttpGet("{id}/restaurants")]
        public async Task<IActionResult> GetRestaurantsByLocationId(int id)
        {
            var restaurants = await _locationService.GetRestaurantsByLocationIdAsync(id);
            return Ok(restaurants);
        }

        [HttpGet("{id}/hotels")]
        public async Task<IActionResult> GetHotelsByLocationId(int id)
        {
            var hotels = await _locationService.GetHotelsByLocationIdAsync(id);
            return Ok(hotels);
        }

        [HttpGet("restaurants/search")]
        public async Task<IActionResult> SearchRestaurantsByText([FromQuery] string textQuery, [FromQuery] string? provinceName = null)
        {
            var places = await _locationService.SearchRestaurantsByTextAsync(textQuery, provinceName);
            return Ok(places);
        }
    }
}

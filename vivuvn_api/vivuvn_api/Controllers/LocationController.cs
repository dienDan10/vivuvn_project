using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Helpers;
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
        [Authorize(Roles = $"{Constants.Role_Admin},{Constants.Role_Operator},{Constants.Role_Traveler}")]
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
                return NotFound("Không tìm thấy địa điểm");
            }

            return Ok(locations);
        }

        [HttpGet("top-travel-locations")]
        public async Task<IActionResult> GetTopTravelLocations([FromQuery] int? limit)
        {
            var locations = await _locationService.GetTopTravelLocationsAsync(limit ?? Constants.DefaultTopLocationsLimit);
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

        [HttpGet("hotels/search")]
        public async Task<IActionResult> SearchHotelsByText([FromQuery] string textQuery, [FromQuery] string? provinceName = null)
        {
            var places = await _locationService.SearchHotelsByTextAsync(textQuery, provinceName);
            return Ok(places);
        }

        [HttpPost]
        [Authorize(Roles = $"{Constants.Role_Admin},{Constants.Role_Operator}")]
        public async Task<IActionResult> CreateLocation([FromForm] CreateLocationRequestDto requestDto)
        {
            var location = await _locationService.CreateLocationAsync(requestDto);
            return CreatedAtAction(nameof(GetLocationById), new { id = location.Id }, location);
        }

        [HttpPut("{id:int}")]
        [Authorize(Roles = $"{Constants.Role_Admin},{Constants.Role_Operator}")]
        public async Task<IActionResult> UpdateLocation(int id, [FromForm] UpdateLocationRequestDto requestDto)
        {
            var location = await _locationService.UpdateLocationAsync(id, requestDto);
            return Ok(location);
        }

        [HttpDelete("{id:int}")]
        [Authorize(Roles = $"{Constants.Role_Admin},{Constants.Role_Operator}")]
        public async Task<IActionResult> DeleteLocation(int id)
        {
            await _locationService.DeleteLocationAsync(id);
            return Ok();
        }

        [HttpPut("{id:int}/restore")]
        [Authorize(Roles = $"{Constants.Role_Admin},{Constants.Role_Operator}")]
        public async Task<IActionResult> RestoreLocation(int id)
        {
            var location = await _locationService.RestoreLocationAsync(id);
            return Ok(location);
        }
    }
}

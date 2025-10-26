using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries/{itineraryId}/restaurants")]
    [ApiController]
    public class ItineraryRestaurantController(IitineraryRestaurantService _itineraryRestaurantService) : ControllerBase
    {
        [HttpPost("suggestions")]
        [Authorize]
        public async Task<IActionResult> AddRestaurantToItineraryFromSuggestion(int itineraryId, [FromBody] AddRestaurantToItineraryFromSuggestionDto request)
        {
            await _itineraryRestaurantService.AddRestaurantToItineraryFromSuggestionAsync(itineraryId, request);

            return Ok(new { message = "Restaurant added to itinerary successfully." });
        }

        [HttpPost("search")]
        [Authorize]
        public async Task<IActionResult> AddRestaurantToItineraryFromSearch(int itineraryId, [FromBody] AddRestaurantToItineraryFromSearch request)
        {
            await _itineraryRestaurantService.AddRestaurantToItineraryFromSearchAsync(itineraryId, request);
            return Ok(new { message = "Restaurant added to itinerary successfully." });
        }
    }
}

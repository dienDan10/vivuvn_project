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
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetRestaurantsInItinerary(int itineraryId)
        {
            var restaurants = await _itineraryRestaurantService.GetRestaurantsInItineraryAsync(itineraryId);
            return Ok(restaurants);
        }

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

        [HttpPut("{itineraryRestaurantId}/notes")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryRestaurant(int itineraryId, int itineraryRestaurantId, [FromBody] string notes)
        {
            await _itineraryRestaurantService.UpdateNotesAsync(itineraryId, itineraryRestaurantId, notes);
            return Ok(new { message = "Itinerary restaurant updated successfully." });
        }

        [HttpPut("{itineraryRestaurantId}/dates")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryRestaurantDateTime(int itineraryId, int itineraryRestaurantId, [FromBody] DateOnly date)
        {
            await _itineraryRestaurantService.UpdateDateAsync(itineraryId, itineraryRestaurantId, date);
            return Ok(new { message = "Itinerary restaurant date and time updated successfully." });
        }

        [HttpPut("{itineraryRestaurantId}/times")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryRestaurantTime(int itineraryId, int itineraryRestaurantId, [FromBody] TimeOnly time)
        {
            await _itineraryRestaurantService.UpdateTimeAsync(itineraryId, itineraryRestaurantId, time);
            return Ok(new { message = "Itinerary restaurant time updated successfully." });
        }

        [HttpPut("{itineraryRestaurantId}/costs")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryRestaurantCost(int itineraryId, int itineraryRestaurantId, [FromBody] decimal cost)
        {
            await _itineraryRestaurantService.UpdateCostAsync(itineraryId, itineraryRestaurantId, cost);
            return Ok(new { message = "Itinerary restaurant cost updated successfully." });

        }
    }
}

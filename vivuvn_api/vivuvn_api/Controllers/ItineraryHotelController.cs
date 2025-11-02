using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries/{itineraryId}/hotels")]
    [ApiController]
    public class ItineraryHotelController(IitineraryHotelService _itineraryHotelService) : ControllerBase
    {
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetHotelsInItinerary(int itineraryId)
        {
            var hotels = await _itineraryHotelService.GetHotelsInItineraryAsync(itineraryId);
            return Ok(hotels);
        }

        [HttpPost("suggestions")]
        [Authorize]
        public async Task<IActionResult> AddHotelToItineraryFromSuggestion(int itineraryId, [FromBody] AddHotelToItineraryFromSuggestionDto request)
        {
            await _itineraryHotelService.AddHotelToItineraryFromSuggestionAsync(itineraryId, request);

            return Ok(new { message = "Hotel added to itinerary successfully." });
        }

        [HttpPost("search")]
        [Authorize]
        public async Task<IActionResult> AddHotelToItineraryFromSearch(int itineraryId, [FromBody] AddHotelToItineraryFromSearch request)
        {
            await _itineraryHotelService.AddHotelToItineraryFromSearchAsync(itineraryId, request);
            return Ok(new { message = "Hotel added to itinerary successfully." });
        }

        [HttpPut("{itineraryHotelId}/notes")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryHotelNotes(int itineraryId, int itineraryHotelId, [FromBody] UpdateNoteRequestDto requestDto)
        {
            await _itineraryHotelService.UpdateNotesAsync(itineraryId, itineraryHotelId, requestDto.Notes);
            return Ok(new { message = "Itinerary hotel notes updated successfully." });
        }

        [HttpPut("{itineraryHotelId}/dates")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryHotelDates(int itineraryId, int itineraryHotelId, [FromBody] UpdateHotelCheckInCheckOutDateRequestDto request)
        {
            await _itineraryHotelService.UpdateCheckInCheckOutAsync(itineraryId, itineraryHotelId, request.CheckIn, request.CheckOut);
            return Ok(new { message = "Itinerary hotel check-in and check-out dates updated successfully." });
        }

        [HttpPut("{itineraryHotelId}/costs")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryHotelCost(int itineraryId, int itineraryHotelId, [FromBody] UpdateCostRequestDto request)
        {
            if (request.Cost == 0)
            {
                return BadRequest("Cost must be greater than 0");
            }

            await _itineraryHotelService.UpdateCostAsync(itineraryId, itineraryHotelId, request.Cost);
            return Ok(new { message = "Itinerary hotel cost updated successfully." });
        }

        [HttpDelete("{itineraryHotelId}")]
        [Authorize]
        public async Task<IActionResult> DeleteItineraryHotel(int itineraryId, int itineraryHotelId)
        {
            await _itineraryHotelService.DeleteItineraryHotelAsync(itineraryId, itineraryHotelId);
            return Ok(new { message = "Itinerary hotel deleted successfully." });
        }
    }
}

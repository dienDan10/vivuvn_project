using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries/{itineraryId}/days")]
    [ApiController]
    public class ItineraryScheduleController(IItineraryItemService _itineraryItemService,
        IItineraryService _itineraryService) : ControllerBase
    {
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetScheduleOfItinerary(int itineraryId)
        {
            var schedule = await _itineraryService.GetItineraryScheduleAsync(itineraryId);
            return Ok(schedule);
        }


        [HttpPost("{dayId}/items")]
        [Authorize]
        public async Task<IActionResult> AddItemToDay(int itineraryId, int dayId,
            [FromBody] AddItineraryDayItemRequestDto request)
        {
            await _itineraryItemService.AddItemToDayAsync(itineraryId, dayId, request);
            return Ok();
        }
    }
}

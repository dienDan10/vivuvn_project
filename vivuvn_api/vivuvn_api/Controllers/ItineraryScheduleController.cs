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
        #region Schedule days
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetScheduleOfItinerary(int itineraryId)
        {
            var schedule = await _itineraryService.GetItineraryScheduleAsync(itineraryId);
            return Ok(schedule);
        }
        #endregion

        #region Schedule items

        [HttpGet("{dayId}/items")]
        [Authorize]
        public async Task<IActionResult> GetDaySchedule(int dayId)
        {
            var items = await _itineraryItemService.GetItemsByDayIdAsync(dayId);
            return Ok(items);
        }

        [HttpPost("{dayId}/items")]
        [Authorize]
        public async Task<IActionResult> AddItemToDay(int dayId,
            [FromBody] AddItineraryDayItemRequestDto request)
        {
            await _itineraryItemService.AddItemToDayAsync(dayId, request);
            return Ok();
        }

        #endregion
    }
}

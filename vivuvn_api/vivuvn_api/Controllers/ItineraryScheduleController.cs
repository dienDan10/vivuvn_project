using Microsoft.AspNetCore.Mvc;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries/{itineraryId}/days")]
    [ApiController]
    public class ItineraryScheduleController(IItineraryItemService _itineraryItemService) : ControllerBase
    {
        [HttpPost("{dayId}/items")]
        public async Task<IActionResult> AddItemToDay(int itineraryId, int dayId,
            [FromBody] AddItineraryDayItemRequestDto request)
        {
            await _itineraryItemService.AddItemToDayAsync(itineraryId, dayId, request);
            return Ok();
        }
    }
}

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

        [HttpPost]
        [Authorize]
        [Route("auto-generate")]
        public async Task<IActionResult> AutoGenerateItinerary(int itineraryId, [FromBody] AutoGenerateItineraryRequest request)
        {
            // auto-generate itinerary
            var response = await _itineraryService.AutoGenerateItineraryAsync(itineraryId, request);
            return Ok(response);
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

        [HttpPut("{dayId}/items/{itemId}")]
        [Authorize]
        public async Task<IActionResult> UpdateItemInDay(int itemId,
            [FromBody] UpdateItineraryItemRequestDto request)
        {
            var item = await _itineraryItemService.UpdateItineraryItemAsync(itemId, request);
            return Ok(item);
        }

        [HttpPut("{dayId}/items/{itemId}/routes")]
        [Authorize]
        public async Task<IActionResult> UpdateItemRouteInfoInDay(int itemId,
            [FromBody] UpdateItineraryItemRouteInfoRequestDto request)
        {
            var item = await _itineraryItemService.UpdateItineraryItemRouteInfoAsync(itemId, request);
            return Ok(item);
        }

        [HttpDelete("{dayId}/items/{itemId}")]
        [Authorize]
        public async Task<IActionResult> RemoveItemFromDay(int dayId, int itemId)
        {
            await _itineraryItemService.RemoveItemFromDayAsync(dayId, itemId);
            return Ok();
        }

        #endregion
    }
}

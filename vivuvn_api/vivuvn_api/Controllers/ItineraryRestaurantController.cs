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

            return Ok(new { message = "Đã thêm nhà hàng vào lịch trình thành công." });
        }

        [HttpPost("search")]
        [Authorize]
        public async Task<IActionResult> AddRestaurantToItineraryFromSearch(int itineraryId, [FromBody] AddRestaurantToItineraryFromSearch request)
        {
            await _itineraryRestaurantService.AddRestaurantToItineraryFromSearchAsync(itineraryId, request);
            return Ok(new { message = "Đã thêm nhà hàng vào lịch trình thành công." });
        }

        [HttpPut("{itineraryRestaurantId}/notes")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryRestaurant(int itineraryId, int itineraryRestaurantId, [FromBody] UpdateNoteRequestDto requestDto)
        {
            await _itineraryRestaurantService.UpdateNotesAsync(itineraryId, itineraryRestaurantId, requestDto.Notes);
            return Ok(new { message = "Đã cập nhật nhà hàng thành công." });
        }

        [HttpPut("{itineraryRestaurantId}/dates")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryRestaurantDateTime(int itineraryId, int itineraryRestaurantId, [FromBody] UpdateDateRequestDto request)
        {
            await _itineraryRestaurantService.UpdateDateAsync(itineraryId, itineraryRestaurantId, request.Date);
            return Ok(new { message = "Đã cập nhật ngày và giờ nhà hàng thành công." });
        }

        [HttpPut("{itineraryRestaurantId}/times")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryRestaurantTime(int itineraryId, int itineraryRestaurantId, [FromBody] UpdateTimeRequestDto request)
        {
            await _itineraryRestaurantService.UpdateTimeAsync(itineraryId, itineraryRestaurantId, request.Time);
            return Ok(new { message = "Đã cập nhật giờ nhà hàng thành công." });
        }

        [HttpPut("{itineraryRestaurantId}/costs")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryRestaurantCost(int itineraryId, int itineraryRestaurantId, [FromBody] UpdateCostRequestDto request)
        {
            if (request.Cost == 0)
            {
                return BadRequest("Chi phí phải lớn hơn 0");
            }

            await _itineraryRestaurantService.UpdateCostAsync(itineraryId, itineraryRestaurantId, request.Cost);
            return Ok(new { message = "Đã cập nhật chi phí nhà hàng thành công." });

        }

        [HttpDelete("{itineraryRestaurantId}")]
        [Authorize]
        public async Task<IActionResult> DeleteItineraryRestaurant(int itineraryId, int itineraryRestaurantId)
        {
            await _itineraryRestaurantService.DeleteItineraryRestaurantAsync(itineraryId, itineraryRestaurantId);
            return Ok(new { message = "Đã xóa nhà hàng khỏi lịch trình thành công." });
        }
    }
}

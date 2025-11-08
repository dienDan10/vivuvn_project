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

            return Ok(new { message = "Đã thêm khách sạn vào lịch trình thành công." });
        }

        [HttpPost("search")]
        [Authorize]
        public async Task<IActionResult> AddHotelToItineraryFromSearch(int itineraryId, [FromBody] AddHotelToItineraryFromSearch request)
        {
            await _itineraryHotelService.AddHotelToItineraryFromSearchAsync(itineraryId, request);
            return Ok(new { message = "Đã thêm khách sạn vào lịch trình thành công." });
        }

        [HttpPut("{itineraryHotelId}/notes")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryHotelNotes(int itineraryId, int itineraryHotelId, [FromBody] UpdateNoteRequestDto requestDto)
        {
            await _itineraryHotelService.UpdateNotesAsync(itineraryId, itineraryHotelId, requestDto.Notes);
            return Ok(new { message = "Đã cập nhật ghi chú khách sạn thành công." });
        }

        [HttpPut("{itineraryHotelId}/dates")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryHotelDates(int itineraryId, int itineraryHotelId, [FromBody] UpdateHotelCheckInCheckOutDateRequestDto request)
        {
            await _itineraryHotelService.UpdateCheckInCheckOutAsync(itineraryId, itineraryHotelId, request.CheckIn, request.CheckOut);
            return Ok(new { message = "Đã cập nhật ngày nhận phòng và trả phòng thành công." });
        }

        [HttpPut("{itineraryHotelId}/costs")]
        [Authorize]
        public async Task<IActionResult> UpdateItineraryHotelCost(int itineraryId, int itineraryHotelId, [FromBody] UpdateCostRequestDto request)
        {
            if (request.Cost == 0)
            {
                return BadRequest("Chi phí phải lớn hơn 0");
            }

            await _itineraryHotelService.UpdateCostAsync(itineraryId, itineraryHotelId, request.Cost);
            return Ok(new { message = "Đã cập nhật chi phí khách sạn thành công." });
        }

        [HttpDelete("{itineraryHotelId}")]
        [Authorize]
        public async Task<IActionResult> DeleteItineraryHotel(int itineraryId, int itineraryHotelId)
        {
            await _itineraryHotelService.DeleteItineraryHotelAsync(itineraryId, itineraryHotelId);
            return Ok(new { message = "Đã xóa khách sạn khỏi lịch trình thành công." });
        }
    }
}

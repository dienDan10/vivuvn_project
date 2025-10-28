using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries/{itineraryId}/hotels")]
    [ApiController]
    public class ItineraryHotelController(IitineraryHotelService _itineraryHotelService) : ControllerBase
    {
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetRestaurantsInItinerary(int itineraryId)
        {
            var restaurants = await _itineraryHotelService.GetHotelsInItineraryAsync(itineraryId);
            return Ok(restaurants);
        }
    }
}

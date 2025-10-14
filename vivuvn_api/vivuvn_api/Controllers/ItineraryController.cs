using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries")]
    [ApiController]
    public class ItineraryController(IItineraryService _itineraryService, IFavoritePlaceService _favoritePlaceService) : ControllerBase
    {
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetAllItineraries()
        {
            // get user id from token
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (userId == null)
            {
                return Unauthorized(new { message = "User ID claim is missing." });
            }

            // get all itineraries by user id
            var itineraries = await _itineraryService.GetAllItinerariesByUserIdAsync(int.Parse(userId));

            return Ok(itineraries);
        }

        [HttpGet("{id}")]
        [Authorize]
        public async Task<IActionResult> GetItineraryById(int id)
        {
            var itinerary = await _itineraryService.GetItineraryByIdAsync(id);

            return Ok(itinerary);
        }

        [HttpPost]
        [Authorize]
        public async Task<IActionResult> CreateItinerary([FromBody] CreateItineraryRequestDto request)
        {
            // get user id from token
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (userId == null)
            {
                return Unauthorized(new { message = "User ID claim is missing." });
            }

            // create itinerary
            var response = await _itineraryService.CreateItineraryAsync(int.Parse(userId), request);

            return Ok(response);
        }

        [HttpPost("{itineraryId}/favorite-places")]
        [Authorize]
        public async Task<IActionResult> AddFavoritePlace(int itineraryId, [FromBody] AddFavoritePlaceRequestDto request)
        {
            await _favoritePlaceService.AddFavoritePlaceAsync(itineraryId, request.LocationId);
            return Ok();
        }

        [HttpDelete("{itineraryId}/favorite-places/{locationId}")]
        [Authorize]
        public async Task<IActionResult> RemoveFavoritePlace(int itineraryId, int locationId)
        {
            await _favoritePlaceService.RemoveFavoritePlaceAsync(itineraryId, locationId);
            return Ok();
        }
    }
}

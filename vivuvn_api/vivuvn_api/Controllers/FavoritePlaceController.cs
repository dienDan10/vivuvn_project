using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries/{itineraryId}/favorite-places")]
    [ApiController]
    public class FavoritePlaceController(IFavoritePlaceService _favoritePlaceService) : ControllerBase
    {
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetFavoritePlaces(int itineraryId)
        {
            var favoritePlaces = await _favoritePlaceService.GetFavoritePlacesByItineraryIdAsync(itineraryId);
            return Ok(favoritePlaces);
        }

        [HttpPost]
        [Authorize]
        public async Task<IActionResult> AddFavoritePlace(int itineraryId, [FromBody] AddFavoritePlaceRequestDto request)
        {
            await _favoritePlaceService.AddFavoritePlaceAsync(itineraryId, request.LocationId);
            return Ok();
        }

        [HttpDelete("{locationId}")]
        [Authorize]
        public async Task<IActionResult> RemoveFavoritePlace(int itineraryId, int locationId)
        {
            await _favoritePlaceService.RemoveFavoritePlaceAsync(itineraryId, locationId);
            return Ok();
        }
    }
}

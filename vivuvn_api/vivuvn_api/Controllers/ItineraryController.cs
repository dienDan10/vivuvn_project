using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries")]
    [ApiController]
    public class ItineraryController(IItineraryService _itineraryService) : ControllerBase
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
        public Task<IActionResult> GetItineraryById(int id)
        {
            // Logic to retrieve a specific itinerary by ID would go here
            return Task.FromResult<IActionResult>(Ok(new { message = $"Itinerary details for ID: {id}" }));
        }
    }
}

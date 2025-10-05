using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/users")]
    [ApiController]
    [Authorize]
    public class UserController(IUserService _userService) : ControllerBase
    {

        [HttpGet("me")]
        public async Task<IActionResult> GetProfile()
        {
            var email = User.FindFirstValue(ClaimTypes.Email);

            if (email == null)
            {
                return Unauthorized(new { message = "Email claim is missing." });
            }

            var profile = await _userService.GetProfileAsync(email);
            return Ok(profile);
        }
    }
}

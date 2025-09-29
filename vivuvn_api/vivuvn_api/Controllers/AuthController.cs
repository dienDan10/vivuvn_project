using Microsoft.AspNetCore.Mvc;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/auth")]
    [ApiController]
    public class AuthController(IAuthService _authService) : ControllerBase
    {
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] DTOs.Request.LoginRequestDto request)
        {
            var result = await _authService.LoginAsync(request);
            if (result.IsFailed)
            {
                return BadRequest(new { Errors = result.Errors.Select(e => e.Message) });
            }
            return Ok(result.Value);
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] DTOs.Request.RegisterRequestDto request)
        {
            var result = await _authService.RegisterAsync(request);
            if (result.IsFailed)
            {
                return BadRequest(new { Errors = result.Errors.Select(e => e.Message) });
            }
            return Ok(result.Value);
        }

        [HttpPost("refresh-token")]
        public async Task<IActionResult> RefreshToken([FromBody] DTOs.Request.RefreshTokenRequestDto request)
        {
            var result = await _authService.RefreshTokenAsync(request);
            if (result.IsFailed)
            {
                return BadRequest(new { Errors = result.Errors.Select(e => e.Message) });
            }
            return Ok(result.Value);
        }

    }
}

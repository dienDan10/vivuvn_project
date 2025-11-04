using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/users/devices")]
    [ApiController]
    public class UserDeviceController(IUserDeviceService _deviceService) : ControllerBase
    {

        [HttpPost]
        [Authorize]
        public async Task<IActionResult> RegisterDevice([FromBody] RegisterDeviceRequestDto request)
        {
            var userId = GetCurrentUserId();
            await _deviceService.RegisterDeviceAsync(userId, request);
            return Ok();
        }

        [HttpDelete("{fcmToken}")]
        public async Task<IActionResult> DeactivateDevice(string fcmToken)
        {
            await _deviceService.DeactivateDeviceAsync(fcmToken);
            return Ok();
        }

        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirstValue(ClaimTypes.NameIdentifier);
            return int.Parse(userIdClaim!);
        }
    }
}

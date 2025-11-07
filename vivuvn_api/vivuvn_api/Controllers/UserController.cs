using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using vivuvn_api.Helpers;
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
                return Unauthorized(new { message = "Thiếu thông tin email." });
            }

            var profile = await _userService.GetProfileAsync(email);
            return Ok(profile);
        }

        [HttpPut("{userId}/lock")]
        [Authorize(Roles = $"{Constants.Role_Admin}")]
        public async Task<IActionResult> LockUserAccount(int userId)
        {
            var result = await _userService.LockUserAccountAsync(userId);
            if (result is null)
            {
                return NotFound(new { message = "Không tìm thấy người dùng." });
            }
            return Ok(new { message = "Đã khóa tài khoản người dùng thành công." });
        }

        [HttpPut("{userId}/unlock")]
        [Authorize(Roles = $"{Constants.Role_Admin}")]
        public async Task<IActionResult> UnlockUserAccount(int userId)
        {
            var result = await _userService.UnlockUserAccountAsync(userId);
            if (result is null)
            {
                return NotFound(new { message = "Không tìm thấy người dùng." });
            }
            return Ok(new { message = "Đã mở khóa tài khoản người dùng thành công." });
        }
    }
}

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using vivuvn_api.DTOs.Request;
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

        [HttpGet]
        [Authorize(Roles = $"{Constants.Role_Admin}")]
        public async Task<IActionResult> GetAllUsers([FromQuery] GetAllUsersRequestDto requestDto)
        {
            var users = await _userService.GetAllUsersAsync(requestDto);
            return Ok(users);
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

        [HttpPut("{userId}/avatar")]
        [Authorize]
        public async Task<IActionResult> ChangeAvatar(int userId, [FromForm] ChangeAvatarRequest request)
        {
            var result = await _userService.ChangeAvatarAsync(userId, request.Avatar);
            if (result is null)
            {
                return NotFound(new { message = "Không tìm thấy người dùng hoặc bạn không có quyền thay đổi avatar này." });
            }
            return Ok(new { message = "Đã thay đổi avatar thành công.", Url = result });
        }

        [HttpPut("{userId}/username")]
        [Authorize]
        public async Task<IActionResult> ChangeUsername(int userId, [FromBody] ChangeUsernameRequest request)
        {
            var result = await _userService.ChangeUsername(userId, request.Username);
            if (result is null)
            {
                return NotFound(new { message = "Không tìm thấy người dùng hoặc bạn không có quyền thay đổi tên người dùng này." });
            }
            return Ok(new { message = "Đã thay đổi tên người dùng thành công.", NewName = result });
        }

        [HttpPut("{userId}/phone-number")]
        [Authorize]
        public async Task<IActionResult> ChangePhoneNumber(int userId, [FromBody] ChangePhoneNumberRequest request)
        {
            var result = await _userService.ChangePhoneNumber(userId, request.PhoneNumber);
            if (result is null)
            {
                return NotFound(new { message = "Không tìm thấy người dùng hoặc bạn không có quyền thay đổi số điện thoại này." });
            }
            return Ok(new { message = "Đã thay đổi số điện thoại thành công.", NewPhoneNumber = result });
        }

        [HttpPost("operator")]
        [Authorize(Roles = $"{Constants.Role_Admin}")]
        public async Task<IActionResult> CreateOperator([FromBody] CreateOperatorRequestDto requestDto)
        {
            var newOperator = await _userService.CreateOperatorAsync(requestDto);
			return Ok(newOperator);
        }
    }
}

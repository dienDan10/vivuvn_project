using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/auth")]
    [ApiController]
    public class AuthController(IAuthService _authService) : ControllerBase
    {

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequestDto request)
        {
            var tokenResponseDto = await _authService.LoginAsync(request);
            return Ok(tokenResponseDto);
        }

        [HttpPost("google-login")]
        public async Task<IActionResult> GoogleLogin([FromBody] GoogleLoginRequestDto request)
        {
            var result = await _authService.GoogleLoginAsync(request);
            return Ok(result);
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequestDto request)
        {
            await _authService.RegisterAsync(request);
            return Ok(new
            {
                Message = "Đăng ký thành công! Vui lòng kiểm tra email để xác nhận đăng ký."
            });
        }

        [HttpPost("verify-email")]
        public async Task<IActionResult> VerifyEmail([FromBody] VerifyEmailRequestDto request)
        {
            await _authService.VerifyEmailAsync(request);
            return Ok(new
            {
                Message = "Xác thực email thành công!"
            });
        }

        [HttpPost("resend-verification")]
        public async Task<IActionResult> ResendVerificationEmail([FromBody] ResendEmailVerificationRequestDto request)
        {
            await _authService.ResendEmailVerificationAsync(request);
            return Ok();
        }

        [HttpPost("refresh-token")]
        public async Task<IActionResult> RefreshToken([FromBody] RefreshTokenRequestDto request)
        {
            var result = await _authService.RefreshTokenAsync(request);
            return Ok(result);
        }

        [HttpPost("change-password")]
        [Authorize]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordRequestDto request)
        {
            int userId = GetCurrentUserId();
            await _authService.ChangePasswordAsync(userId, request);
            return Ok(new
            {
                Message = "Đổi mật khẩu thành công!"
            });
        }

        [HttpPost("forgot-password")]
        public async Task<IActionResult> ForgotPassword([FromBody] ForgotPasswordRequestDto request)
        {
            await _authService.RequestPasswordResetAsync(request);
            return Ok(new
            {
                Message = "Nếu email tồn tại trong hệ thống, một email đặt lại mật khẩu đã được gửi."
            });
        }

        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordRequestDto request)
        {
            await _authService.ResetPasswordAsync(request);
            return Ok(new
            {
                Message = "Đặt lại mật khẩu thành công!"
            });
        }

        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirstValue(ClaimTypes.NameIdentifier);
            return int.Parse(userIdClaim!);
        }

    }
}

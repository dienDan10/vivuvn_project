using AutoMapper;
using Google.Apis.Auth;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using vivuvn_api.Data;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class AuthService(IUnitOfWork _unitOfWork, ITokenService _tokenService, IEmailService _emailService, IConfiguration _config, IMapper _mapper) : IAuthService
    {
        public async Task<LoginResponseDto> LoginAsync(LoginRequestDto request)
        {
			var user = await _unitOfWork.Users.GetOneAsync(u => u.Email == request.Email, includeProperties: "UserRoles,UserRoles.Role");

			if (user == null) throw new BadHttpRequestException("Email hoặc mật khẩu không đúng");

			var passwordVerificationResult = new PasswordHasher<User>().VerifyHashedPassword(user, user.PasswordHash, request.Password);

			if (passwordVerificationResult == PasswordVerificationResult.Failed) throw new BadHttpRequestException("Email hoặc mật khẩu không đúng");

			// Check if user is locked
			if (user.LockoutEnd.HasValue && user.LockoutEnd.Value > DateTime.UtcNow) throw new BadHttpRequestException("Tài khoản này đã bị khóa");

			// Check if email is verified
			if (!user.IsEmailVerified) throw new BadHttpRequestException("Email chưa được xác thực");

			var tokenResponse = await CreateTokenResponse(user);

            return new LoginResponseDto
            {
                AccessToken = tokenResponse.AccessToken,
                RefreshToken = tokenResponse.RefreshToken,
                User = _mapper.Map<DTOs.ValueObjects.UserDto>(user)
            };
        }


		public async Task<TokenResponseDto> GoogleLoginAsync([FromBody] GoogleLoginRequestDto request)
		{
			try
			{
				// 1️⃣ Verify Google ID token
				var payload = await GoogleJsonWebSignature.ValidateAsync(request.IdToken,
					new GoogleJsonWebSignature.ValidationSettings
					{
						Audience = new[] { _config["GoogleOAuth:ClientId"] } // Web client ID
					});

				// 2️⃣ Extract user info
				var email = payload.Email;
				var name = payload.Name;
				var picture = payload.Picture;
				var googleId = payload.Subject;

				// Find or create user in  DB
				var user = await _unitOfWork.Users.GetOneAsync(u => u.Email == email, includeProperties: "UserRoles,UserRoles.Role");

				if (user == null)
				{
					// Create new user
					user = new User
					{
						Email = email,
						Username = name,
						UserPhoto = picture,
						GoogleIdToken = googleId,
						IsEmailVerified = true // Assume email is verified by Google
					};
					// Assign "Traveler" role by default
					var travelerRole = await _unitOfWork.Roles.GetOneAsync(r => r.Name == Constants.Role_Traveler);
					if (travelerRole == null)
					{
						throw new Exception("Đã xảy ra lỗi không mong đợi");
					}
					user.UserRoles = new List<UserRole> { new UserRole { RoleId = travelerRole.Id } };
					await _unitOfWork.Users.AddAsync(user);
					await _unitOfWork.SaveChangesAsync();
				}

				// Generate JWT token
				return await CreateTokenResponse(user);

			}
			catch (InvalidJwtException)
			{
				throw new UnauthorizedAccessException("Token Google không hợp lệ");
			}
			catch (Exception ex)
			{
				throw new BadHttpRequestException("Đăng nhập bằng Google thất bại");
			}
		}

		public async Task RegisterAsync(RegisterRequestDto request)
		{
			var user = await _unitOfWork.Users.GetOneAsync(u => u.Email == request.Email);

			// if user is a google user, don't need to send verification email
			if (user is not null && user.GoogleIdToken is not null)
			{
				user.Username = request.Username;
				user.PasswordHash = HashPassword(user, request.Password);
				_unitOfWork.Users.Update(user);
				await _unitOfWork.SaveChangesAsync();
				return;
			}

			// if user exists but email not verified, resend verification email
			if (user is not null && !user.IsEmailVerified)
			{
				// Send verification email again
				user.Username = request.Username;
				user.PasswordHash = HashPassword(user, request.Password);

				await CreateAndSendEmailVerificationToken(user);
				return;
			}

			// if user exists and email verified, throw error
			if (user is not null)
			{
				throw new BadHttpRequestException("Email đã được sử dụng");
			}

			var newUser = new User
			{
				Email = request.Email,
				Username = request.Username,
				IsEmailVerified = false,
			};

			newUser.PasswordHash = HashPassword(newUser, request.Password);

			// Assign "Traveler" role by default
			var travelerRole = await _unitOfWork.Roles.GetOneAsync(r => r.Name == Constants.Role_Traveler);

			if (travelerRole == null)
			{
				throw new Exception("Đã xảy ra lỗi không mong đợi");
			}

			newUser.UserRoles = new List<UserRole> { new UserRole { RoleId = travelerRole.Id } };


			// Add user to db
			await _unitOfWork.Users.AddAsync(newUser);
			await _unitOfWork.SaveChangesAsync();

			// Send Email to User
			await CreateAndSendEmailVerificationToken(newUser);

			return;
		}

		public async Task VerifyEmailAsync(VerifyEmailRequestDto request)
		{
			var user = await _unitOfWork.Users.GetOneAsync(u => u.Email == request.Email);
			if (user == null) throw new BadHttpRequestException("Không tìm thấy người dùng");
			if (user.IsEmailVerified) return;
			if (user.EmailVerificationToken != request.Token || user.EmailVerificationTokenExpireDate <= DateTime.UtcNow)
			{

				throw new BadHttpRequestException("Mã xác thực không hợp lệ hoặc đã hết hạn");
			}
			user.IsEmailVerified = true;
			user.EmailVerificationToken = null;
			user.EmailVerificationTokenExpireDate = null;
			_unitOfWork.Users.Update(user);
			await _unitOfWork.SaveChangesAsync();
		}

		public async Task ResendEmailVerificationAsync(ResendEmailVerificationRequestDto request)
		{
			var user = await _unitOfWork.Users.GetOneAsync(u => u.Email == request.Email);
			if (user == null) throw new BadHttpRequestException("Không tìm thấy người dùng");
			if (user.IsEmailVerified) return;
			await CreateAndSendEmailVerificationToken(user);
		}

		public async Task<TokenResponseDto> RefreshTokenAsync(RefreshTokenRequestDto request)
		{
			var user = await ValidateRefreshTokenAsync(request.RefreshToken);

			if (user == null) throw new BadHttpRequestException("Refresh token không hợp lệ");

			return await CreateTokenResponse(user);
		}

		public async Task ChangePasswordAsync(int userId, ChangePasswordRequestDto request)
		{
			var user = await _unitOfWork.Users.GetOneAsync(u => u.Id == userId)
				?? throw new BadHttpRequestException("Không tìm thấy người dùng");

			var passwordHasher = new PasswordHasher<User>();

			var passwordVerificationResult = passwordHasher.VerifyHashedPassword(user, user.PasswordHash, request.CurrentPassword);

			if (passwordVerificationResult == PasswordVerificationResult.Failed)
				throw new BadHttpRequestException("Mật khẩu hiện tại không đúng");

			// Check if new password is different from current
			var isSamePassword = passwordHasher.VerifyHashedPassword(user, user.PasswordHash, request.NewPassword);

			if (isSamePassword == PasswordVerificationResult.Success)
				throw new BadHttpRequestException("New password must be different from current password");

			user.PasswordHash = HashPassword(user, request.NewPassword);
			_unitOfWork.Users.Update(user);
			await _unitOfWork.SaveChangesAsync();
		}

		public async Task RequestPasswordResetAsync(ForgotPasswordRequestDto request)
		{
			var user = await _unitOfWork.Users.GetOneAsync(u => u.Email == request.Email);

			if (user is null) return;

			// check if user register via google
			if (user.GoogleIdToken is not null)
			{
				await _emailService.SendPasswordResetNotAvailableEmailAsync(user.Email);
				return;
			}

			// check if there's an existing password reset token
			var existingReset = await _unitOfWork.PasswordResets
				.GetOneAsync(pr => pr.UserId == user.Id);

			// Create password reset token
			var resetToken = _tokenService.CreatePasswordResetToken();

			if (existingReset is not null)
			{
				existingReset.PasswordResetToken = resetToken;
				existingReset.ExpireDate = DateTime.UtcNow.AddMinutes(Constants.PasswordResetTokenExpirationMinutes);
				_unitOfWork.PasswordResets.Update(existingReset);
			}
			else
			{
				var passwordReset = new PasswordReset
				{
					UserId = user.Id,
					PasswordResetToken = resetToken,
					ExpireDate = DateTime.UtcNow.AddMinutes(Constants.PasswordResetTokenExpirationMinutes)
				};

				await _unitOfWork.PasswordResets.AddAsync(passwordReset);
			}

			await _unitOfWork.SaveChangesAsync();
			// Send Email to User
			await _emailService.SendPasswordResetEmailAsync(user.Email, user.Username, resetToken);
		}

		public async Task ResetPasswordAsync(ResetPasswordRequestDto request)
		{
			var user = await _unitOfWork.Users.GetOneAsync(u => u.Email == request.Email)
				?? throw new BadHttpRequestException("Đặt lại mật khẩu không thành công");

			var passwordReset = await _unitOfWork.PasswordResets
				.GetOneAsync(pr => pr.PasswordResetToken == request.Token
				&& pr.UserId == user.Id
				&& pr.ExpireDate > DateTime.UtcNow);

			if (passwordReset is null)
			{
				throw new BadHttpRequestException("Mã đặt lại mật khẩu không hợp lệ hoặc đã hết hạn");
			}

			user.PasswordHash = HashPassword(user, request.NewPassword);
			_unitOfWork.Users.Update(user);
			// Remove password reset token
			_unitOfWork.PasswordResets.Remove(passwordReset);
			await _unitOfWork.SaveChangesAsync();
		}

		private string HashPassword(User user, string password)
		{
			return new PasswordHasher<User>().HashPassword(user, password);
		}

		private async Task CreateAndSendEmailVerificationToken(User user)
		{
			user.EmailVerificationToken = _tokenService.CreateEmailVerificationToken();
			user.EmailVerificationTokenExpireDate = DateTime.UtcNow.AddMinutes(Constants.EmailVerificationTokenExpirationMinutes);
			_unitOfWork.Users.Update(user);
			await _unitOfWork.SaveChangesAsync();
			// Send Email to User
			await _emailService.SendEmailAsync(user.Email, "Email Verification", $"Your verification token is {user.EmailVerificationToken}");
		}

		private async Task<TokenResponseDto> CreateTokenResponse(User user)
		{
			var accessToken = _tokenService.CreateAccessToken(user);
			var refreshToken = await GenerateAndSaveRefreshToken(user);
			return new TokenResponseDto
			{
				AccessToken = accessToken,
				RefreshToken = refreshToken
			};
		}

		private async Task<string> GenerateAndSaveRefreshToken(User user)
		{
			var refreshToken = _tokenService.CreateRefreshToken();
			user.RefreshToken = refreshToken;
			user.RefreshTokenExpireDate = DateTime.UtcNow.AddDays(Constants.RefreshTokenExpirationDays);
			_unitOfWork.Users.Update(user);
			await _unitOfWork.SaveChangesAsync();
			return refreshToken;
		}

		private async Task<User?> ValidateRefreshTokenAsync(string token)
		{
			var user = await _unitOfWork.Users.GetOneAsync(u => u.RefreshToken == token);
			if (user == null || user.RefreshToken == null || user.RefreshTokenExpireDate <= DateTime.UtcNow)
			{
				return null;
			}
			return user;
		}

	}
}
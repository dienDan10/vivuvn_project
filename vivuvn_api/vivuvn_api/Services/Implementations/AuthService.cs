using FluentResults;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using vivuvn_api.Data;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class AuthService(AppDbContext _context, IConfiguration _configuration, ITokenService _tokenService) : IAuthService
    {
        public async Task<Result<TokenResponseDto>> LoginAsync(LoginRequestDto request)
        {
            var user = await _context.Users
                .Include(u => u.UserRoles)
                .ThenInclude(ur => ur.Role)
                .FirstOrDefaultAsync(u => u.Email == request.Email);

            if (user == null) return Result.Fail("Email or Password is incorrect");

            var passwordVerificationResult = new PasswordHasher<User>().VerifyHashedPassword(user, user.PasswordHash, request.Password);

            if (passwordVerificationResult == PasswordVerificationResult.Failed) return Result.Fail("Email or Password is incorrect");

            // Check if user is locked
            if (user.IsLock) return Result.Fail("User is locked");

            // Check if email is verified
            if (!user.IsEmailVerified) return Result.Fail("Email is not verified");

            return await CreateTokenResponse(user);
        }

        public async Task<Result<User>> RegisterAsync(RegisterRequestDto request)
        {
            if (await _context.Users.AnyAsync(u => u.Email == request.Email))
            {
                return Result.Fail("Email is already in use");
            }

            var user = new User
            {
                Email = request.Email,
                Username = request.Username,
                IsEmailVerified = true, // Let the email always be valid for now
            };

            var hashedPassword = new PasswordHasher<User>().HashPassword(user, request.Password);
            user.PasswordHash = hashedPassword;

            user.EmailVerificationToken = _tokenService.CreateEmailVerificationToken();
            user.EmailVerificationTokenExpireDate = DateTime.UtcNow.AddMinutes(Constants.EmailVerificationTokenExpirationMinutes);

            // Assign "Traveler" role by default
            var travelerRole = await _context.Roles.FirstOrDefaultAsync(r => r.Name == Constants.Role_Traveler);

            if (travelerRole == null)
            {
                return Result.Fail("Register failed.");
            }

            user.UserRoles = new List<UserRole> { new UserRole { RoleId = travelerRole.Id } };

            // Send Email to User

            // Add user to db
            await _context.Users.AddAsync(user);
            await _context.SaveChangesAsync();

            return user;
        }

        public async Task<Result<TokenResponseDto>> RefreshTokenAsync(RefreshTokenRequestDto request)
        {
            var user = await ValidateRefreshTokenAsync(request.RefreshToken);

            if (user == null) return Result.Fail("Invalid refresh token");

            return await CreateTokenResponse(user);
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
            _context.Users.Update(user);
            await _context.SaveChangesAsync();
            return refreshToken;
        }

        private async Task<User?> ValidateRefreshTokenAsync(string token)
        {
            var user = await _context.Users
                .Include(u => u.UserRoles)
                .ThenInclude(ur => ur.Role)
                .FirstOrDefaultAsync(u => u.RefreshToken == token);
            if (user == null || user.RefreshToken == null || user.RefreshTokenExpireDate <= DateTime.UtcNow)
            {
                return null;
            }
            return user;
        }

    }
}

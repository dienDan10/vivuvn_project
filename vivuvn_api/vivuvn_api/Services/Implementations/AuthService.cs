using Google.Apis.Auth;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using vivuvn_api.Data;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{

    public class AuthService(AppDbContext _context, ITokenService _tokenService, IEmailService _emailService, IConfiguration _config) : IAuthService
    {
        public async Task<TokenResponseDto> LoginAsync(LoginRequestDto request)
        {
            var user = await _context.Users
                .Include(u => u.UserRoles)
                .ThenInclude(ur => ur.Role)
                .FirstOrDefaultAsync(u => u.Email == request.Email);

            if (user == null) throw new BadHttpRequestException("Email or Password incorrect");

            var passwordVerificationResult = new PasswordHasher<User>().VerifyHashedPassword(user, user.PasswordHash, request.Password);

            if (passwordVerificationResult == PasswordVerificationResult.Failed) throw new BadHttpRequestException("Email or Password incorrect");

            // Check if user is locked
            if (user.LockoutEnd.HasValue && user.LockoutEnd.Value > DateTime.UtcNow) throw new BadHttpRequestException("This account is locked");

            // Check if email is verified
            if (!user.IsEmailVerified) throw new BadHttpRequestException("Email has not been verified");

            return await CreateTokenResponse(user);
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
                var user = await _context.Users
                    .Include(u => u.UserRoles)
                    .ThenInclude(ur => ur.Role)
                    .FirstOrDefaultAsync(u => u.Email == email);

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
                    var travelerRole = await _context.Roles.FirstOrDefaultAsync(r => r.Name == Constants.Role_Traveler);
                    if (travelerRole == null)
                    {
                        throw new Exception("An unexpected error has occurred");
                    }
                    user.UserRoles = new List<UserRole> { new UserRole { RoleId = travelerRole.Id } };
                    await _context.Users.AddAsync(user);
                    await _context.SaveChangesAsync();
                }

                // Generate JWT token
                return await CreateTokenResponse(user);

            }
            catch (InvalidJwtException)
            {
                throw new UnauthorizedAccessException("Invalid Google token");
            }
            catch (Exception ex)
            {
                throw new BadHttpRequestException("Fail to login with google");
            }
        }


        public async Task RegisterAsync(RegisterRequestDto request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == request.Username);

            if (user is not null && user.IsEmailVerified)
            {
                // Send verification email again
                user.Username = request.Username;
                user.PasswordHash = HashPassword(user, request.Password);
                await CreateAndSendEmailVerificationToken(user);
                return;
            }

            if (user is not null)
            {
                throw new BadHttpRequestException("Email is already in use");
            }

            var newUser = new User
            {
                Email = request.Email,
                Username = request.Username,
                IsEmailVerified = false,
            };

            newUser.PasswordHash = HashPassword(newUser, request.Password);

            // Assign "Traveler" role by default
            var travelerRole = await _context.Roles.FirstOrDefaultAsync(r => r.Name == Constants.Role_Traveler);

            if (travelerRole == null)
            {
                throw new Exception("An unexpected error has occurred");
            }

            newUser.UserRoles = new List<UserRole> { new UserRole { RoleId = travelerRole.Id } };


            // Add user to db
            await _context.Users.AddAsync(newUser);
            await _context.SaveChangesAsync();

            // Send Email to User
            await CreateAndSendEmailVerificationToken(newUser);

            return;
        }

        public async Task VerifyEmailAsync(VerifyEmailRequestDto request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == request.Email);
            if (user == null) throw new BadHttpRequestException("User not found");
            if (user.IsEmailVerified) return;
            if (user.EmailVerificationToken != request.Token || user.EmailVerificationTokenExpireDate <= DateTime.UtcNow)
            {

                throw new BadHttpRequestException("Invalid or expired verification token");
            }
            user.IsEmailVerified = true;
            user.EmailVerificationToken = null;
            user.EmailVerificationTokenExpireDate = null;
            _context.Users.Update(user);
            await _context.SaveChangesAsync();
        }

        public async Task ResendEmailVerificationAsync(ResendEmailVerificationRequestDto request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == request.Email);
            if (user == null) throw new BadHttpRequestException("User not found");
            if (user.IsEmailVerified) return;
            await CreateAndSendEmailVerificationToken(user);
        }

        public async Task<TokenResponseDto> RefreshTokenAsync(RefreshTokenRequestDto request)
        {
            var user = await ValidateRefreshTokenAsync(request.RefreshToken);

            if (user == null) throw new BadHttpRequestException("Invalid refresh token");

            return await CreateTokenResponse(user);
        }

        private string HashPassword(User user, string password)
        {
            return new PasswordHasher<User>().HashPassword(user, password);
        }

        private async Task CreateAndSendEmailVerificationToken(User user)
        {
            user.EmailVerificationToken = _tokenService.CreateEmailVerificationToken();
            user.EmailVerificationTokenExpireDate = DateTime.UtcNow.AddMinutes(Constants.EmailVerificationTokenExpirationMinutes);
            _context.Users.Update(user);
            await _context.SaveChangesAsync();
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

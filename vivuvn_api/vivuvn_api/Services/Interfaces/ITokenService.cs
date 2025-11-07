using vivuvn_api.Models;

namespace vivuvn_api.Services.Interfaces
{
    public interface ITokenService
    {
        string CreateAccessToken(User user);
        string CreateRefreshToken();
        string CreateEmailVerificationToken();
        string CreateItineraryInviteToken();
        string CreatePasswordResetToken();
    }
}

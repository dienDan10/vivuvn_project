namespace vivuvn_api.Services.Interfaces
{
    public interface IEmailService
    {
        Task SendEmailAsync(string receiverEmail, string subject, string htmlMessage);
        Task SendPasswordResetEmailAsync(string email, string username, string resetToken);
        Task SendPasswordResetNotAvailableEmailAsync(string email);
    }
}

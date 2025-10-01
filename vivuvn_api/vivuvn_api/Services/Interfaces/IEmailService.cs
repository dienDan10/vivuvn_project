namespace vivuvn_api.Services.Interfaces
{
    public interface IEmailService
    {
        Task SendEmailAsync(string receiverEmail, string subject, string htmlMessage);
    }
}

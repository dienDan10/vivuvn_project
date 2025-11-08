using Microsoft.Extensions.Options;
using sib_api_v3_sdk.Api;
using sib_api_v3_sdk.Model;
using System.Diagnostics;
using vivuvn_api.Helpers;
using vivuvn_api.Services.Interfaces;

using Task = System.Threading.Tasks.Task;

namespace vivuvn_api.Services.Implementations
{
    public class EmailService : IEmailService
    {
        private readonly BrevoSettings _brevoSettings;

        public EmailService(IOptions<BrevoSettings> brevoSettings)
        {
            _brevoSettings = brevoSettings.Value;
        }

        public Task SendEmailAsync(string receiverEmail, string subject, string htmlMessage)
        {
            var apiInstance = new TransactionalEmailsApi();
            // create a sender
            string SenderName = _brevoSettings.SenderName ?? "CineMax";
            string SenderEmail = _brevoSettings.SenderEmail ?? "contact@cinemax.com";
            SendSmtpEmailSender sender = new SendSmtpEmailSender(SenderName, SenderEmail);

            // create a receiver
            string ToName = "Customer";
            SendSmtpEmailTo receiver1 = new SendSmtpEmailTo(receiverEmail, ToName);
            List<SendSmtpEmailTo> To = [receiver1];

            string TextContent = null;

            try
            {
                var sendSmtpEmail = new SendSmtpEmail(sender, To, null, null, htmlMessage, TextContent, subject);
                return apiInstance.SendTransacEmailAsync(sendSmtpEmail);
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.Message);
                Console.WriteLine(e.Message);
                Console.ReadLine();
            }

            return Task.CompletedTask;
        }

        public async Task SendPasswordResetEmailAsync(string email, string username, string resetToken)
        {
            var subject = "Password Reset Request";
            var htmlContent = $@"
                <html>
                <body>
                    <h2>Password Reset</h2>
                    <p>Hi {username},</p>
                    <p>You requested to reset your password. Use the following code to reset your password:</p>
                    <h1 style='color: #4CAF50; letter-spacing: 5px;'>{resetToken}</h1>
                    <p>This code will expire in 1 hour.</p>
                    <p>If you didn't request this, please ignore this email.</p>
                </body>
                </html>
            ";

            await SendEmailAsync(email, subject, htmlContent);
        }

        public async Task SendPasswordResetNotAvailableEmailAsync(string email)
        {
            var subject = "Password Reset Not Available";
            var htmlContent = $@"
                <html>
                <body>
                    <h2>Password Reset Request</h2>
                    <p>You requested to reset your password, but your account uses Google Sign-In.</p>
                    <p>Please continue logging in with your Google account.</p>
                </body>
                </html>
            ";

            await SendEmailAsync(email, subject, htmlContent);
        }
    }
}

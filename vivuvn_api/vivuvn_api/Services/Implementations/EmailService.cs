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
    }
}

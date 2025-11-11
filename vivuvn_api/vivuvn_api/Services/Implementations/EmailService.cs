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
            var subject = "Yêu cầu đặt lại mật khẩu";
            var htmlContent = $@"
                <html>
                <body>
                    <h2>Đặt lại mật khẩu</h2>
                    <p>Chào bạn {username},</p>
                    <p>Bạn đã yêu cầu đặt lại mật khẩu. Sử dụng mã sau để đặt lại mật khẩu của bạn:</p>
                    <h1 style='color: #4CAF50; letter-spacing: 5px;'>{resetToken}</h1>
                    <p>Mã này sẽ hết hạn trong 10 phút.</p>
                    <p>Nếu bạn không yêu cầu điều này, vui lòng bỏ qua email này.</p>
                </body>
                </html>
            ";

            await SendEmailAsync(email, subject, htmlContent);
        }

        public async Task SendPasswordResetNotAvailableEmailAsync(string email)
        {
            var subject = "Không thể đặt lại mật khẩu";
            var htmlContent = $@"
                <html>
                <body>
                    <h2>Yêu cầu đặt lại mật khẩu</h2>
                    <p>Bạn đã yêu cầu đặt lại mật khẩu, nhưng tài khoản của bạn đăng nhập bằng Google.</p>
                    <p>Vui lòng tiếp tục đăng nhập bằng tài khoản Google của bạn.</p>
                </body>
                </html>
            ";

            await SendEmailAsync(email, subject, htmlContent);
        }
    }
}

using Google.Apis.Auth.OAuth2;
using Google.Cloud.Storage.V1;
using vivuvn_api.Helpers;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ImageService : IImageService
    {
        private readonly StorageClient _storageClient;
        private readonly string _bucketName;
        private readonly IWebHostEnvironment _env;

        public ImageService(IWebHostEnvironment env)
        {
            _env = env;
            var creadentialsPath = Path.Combine(_env.ContentRootPath, "Secrets", "fir-basic-3901c-firebase-adminsdk-fbsvc-2d720d3826.json");
            var credentials = GoogleCredential.FromFile(creadentialsPath);
            _storageClient = StorageClient.Create(credentials);
            _bucketName = "fir-basic-3901c.firebasestorage.app";
        }

        public async Task<string> UploadImageAsync(IFormFile file)
        {
            ValidateImage(file);

            // upload image to google cloud storage
            var newFileName = $"vivuvn_image/{Guid.NewGuid()}{Path.GetExtension(file.FileName).ToLower()}";

            var uploadedObject = await _storageClient.UploadObjectAsync(
                bucket: _bucketName,
                objectName: newFileName,
                contentType: file.ContentType,
                source: file.OpenReadStream()
            );

            // newFileName.jpeg
            return $"https://firebasestorage.googleapis.com/v0/b/{_bucketName}/o/{Uri.EscapeDataString(uploadedObject.Name)}?alt=media";
        }

        private bool ValidateImage(IFormFile file)
        {
            if (file.Length > Constants.MaxImageSizeBytes)
            {
                throw new BadHttpRequestException($"Image size exceeds the maximum limit of {Constants.MaxImageSizeBytes} MB.");
            }

            var fileExtension = Path.GetExtension(file.FileName).ToLower();
            if (!Constants.ValidImageExtensions.Contains(fileExtension))
            {
                throw new BadHttpRequestException("Unsupported file extension.");
            }

            return true;
        }
    }
}

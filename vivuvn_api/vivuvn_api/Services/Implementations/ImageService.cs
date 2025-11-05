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

        public ImageService(IWebHostEnvironment env, IConfiguration configuration)
        {
            _env = env;
            var credentialsPath = Path.Combine(_env.ContentRootPath, "Secrets", configuration["Firebase:CredentialFile"]);
            var credentials = GoogleCredential.FromFile(credentialsPath);
            _storageClient = StorageClient.Create(credentials);
            _bucketName = configuration["Firebase:BucketName"];
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

		public async Task<bool> DeleteImageAsync(string fileUrl)
		{
			try
			{
				// Parse objectName from URL
				// URL format: https://firebasestorage.googleapis.com/v0/b/{bucket}/o/{objectName}?alt=media
				var uri = new Uri(fileUrl);
				var segments = uri.Segments;
				var encodedObjectName = segments[^1].Replace("?alt=media", "");
				var objectName = Uri.UnescapeDataString(encodedObjectName);

				await _storageClient.DeleteObjectAsync(_bucketName, objectName);
				return true;
			}
			catch
			{
				return false;
			}
		}
	}
}

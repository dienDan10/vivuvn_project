using vivuvn_api.Helpers;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ImageService(IWebHostEnvironment _env) : IImageService
    {
        public async Task<string> UploadImageAsync(IFormFile file)
        {
            ValidateImage(file);

            // construct the upload path
            var uploadPath = Path.Combine(_env.ContentRootPath, "Images");

            // check if the directory exists, if not create it
            if (!Directory.Exists(uploadPath))
            {
                Directory.CreateDirectory(uploadPath);
            }

            // construct the full file path
            string newFileName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);
            var filePath = Path.Combine(uploadPath, newFileName);

            // save the file
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            // newFileName.jpeg
            return newFileName;
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

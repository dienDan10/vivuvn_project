namespace vivuvn_api.Services.Interfaces
{
    public interface IImageService
    {
		Task<bool> DeleteImageAsync(string fileUrl);
		Task<string> UploadImageAsync(IFormFile file);
	}
}

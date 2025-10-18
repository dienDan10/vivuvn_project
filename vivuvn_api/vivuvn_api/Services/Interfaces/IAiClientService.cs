using vivuvn_api.DTOs.Request;

namespace vivuvn_api.Services.Interfaces
{
    public interface IAiClientService
    {
        Task<T> GenerateItineraryAsync<T>(AutoGenerateItineraryRequest request);
	}
}

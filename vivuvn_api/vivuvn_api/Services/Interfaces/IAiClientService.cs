using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;

namespace vivuvn_api.Services.Interfaces
{
    public interface IAiClientService
    {
        Task<T> GenerateItineraryAsync<T>(AITravelItineraryGenerateRequest request);

		Task<PlaceUpsertResponseDto> InsertPlaceAsync(PlaceUpsertRequestDto placeData);

		Task<PlaceUpsertResponseDto> UpdatePlaceAsync(PlaceUpsertRequestDto placeData);

		Task<PlaceDeleteResponseDto> DeletePlaceAsync(string itemId);
	}
}

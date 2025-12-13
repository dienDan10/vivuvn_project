using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IItineraryService
    {
        Task<IEnumerable<ItineraryDto>> GetAllItinerariesByUserIdAsync(int userId);
        Task<PaginatedResponseDto<SearchItineraryDto>> GetAllPublicItinerariesAsync(GetAllPublicItinerariesRequestDto request);
        Task<int> CopyPublicItineraryAsync(int userId, CopyPublicItineraryRequestDto request);
        Task<ItineraryDto> GetItineraryByIdAsync(int id, int userId);
        Task<CreateItineraryResponseDto> CreateItineraryAsync(int userId, CreateItineraryRequestDto request);
        Task<bool> DeleteItineraryByIdAsync(int id);
        Task UpdateItineraryDatesAsync(int id, UpdateItineraryDatesRequestDto request);
        Task<IEnumerable<ItineraryDayDto>> GetItineraryScheduleAsync(int itineraryId);
        Task<bool> UpdateItineraryNameAsync(int itineraryId, string newName);
        Task<bool> UpdateItineraryGroupSizeAsync(int itineraryId, int newGroupSize);
        Task<bool> SetItineraryToPublicAsync(int itineraryId);
        Task<bool> SetItineraryToPrivateAsync(int itineraryId);
        Task<bool> UpdateItineraryTransportationAsync(int itineraryId, TransportationMode transportation);

        Task<AutoGenerateItineraryResponseDto> AutoGenerateItineraryAsync(int itineraryId, AutoGenerateItineraryRequest request);
    }
}

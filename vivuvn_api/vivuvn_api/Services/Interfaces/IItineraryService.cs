using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IItineraryService
    {
        Task<IEnumerable<ItineraryDto>> GetAllItinerariesByUserIdAsync(int userId);
        Task<ItineraryDto> GetItineraryByIdAsync(int id);
        Task<CreateItineraryResponseDto> CreateItineraryAsync(int userId, CreateItineraryRequestDto request);
        Task<bool> DeleteItineraryByIdAsync(int id);
        Task UpdateItineraryDatesAsync(int id, UpdateItineraryDatesRequestDto request);
        Task<IEnumerable<ItineraryDayDto>> GetItineraryScheduleAsync(int itineraryId);
        Task<bool> UpdateItineraryNameAsync(int itineraryId, string newName);
        Task<bool> UpdateItineraryGroupSizeAsync(int itineraryId, int newGroupSize);
        Task<bool> SetItineraryToPublicAsync(int itineraryId);
        Task<bool> SetItineraryToPrivateAsync(int itineraryId);

        Task<ItineraryDto> AutoGenerateItineraryAsync(int itineraryId, AutoGenerateItineraryRequest request);
    }
}

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
        Task<IEnumerable<ItineraryDayDto>> GetItineraryScheduleAsync(int itineraryId);

        Task<ItineraryDto> AutoGenerateItineraryAsync(int itineraryId, AutoGenerateItineraryRequest request);
    }
}

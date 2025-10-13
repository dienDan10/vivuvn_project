using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Models;

namespace vivuvn_api.Services.Interfaces
{
    public interface IItineraryService
    {
        Task<IEnumerable<ItineraryDto>> GetAllItinerariesByUserIdAsync(int userId);
        Task<Itinerary> GetItineraryByIdAsync(int id);
    }
}

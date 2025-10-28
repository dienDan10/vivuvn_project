using vivuvn_api.DTOs.ValueObjects;

namespace vivuvn_api.Services.Interfaces
{
    public interface IitineraryHotelService
    {
        Task<IEnumerable<ItineraryHotelDto>> GetHotelsInItineraryAsync(int itineraryId);
    }
}

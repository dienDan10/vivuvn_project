using AutoMapper;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryHotelService(IUnitOfWork _unitOfWork, IMapper _mapper) : IitineraryHotelService
    {
        public async Task<IEnumerable<ItineraryHotelDto>> GetHotelsInItineraryAsync(int itineraryId)
        {
            var itineraryHotels = await _unitOfWork.ItineraryHotels.GetAllAsync(ir => ir.ItineraryId == itineraryId, includeProperties: "Hotel,BudgetItem");
            var itineraryHotelDtos = _mapper.Map<IEnumerable<ItineraryHotelDto>>(itineraryHotels);
            return itineraryHotelDtos;
        }
    }
}

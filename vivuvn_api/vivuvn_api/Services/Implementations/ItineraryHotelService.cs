using AutoMapper;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Models;
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

        public async Task AddHotelToItineraryFromSuggestionAsync(int itineraryId, AddHotelToItineraryFromSuggestionDto request)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new BadHttpRequestException("Itinerary not found");

            var itineraryHotel = new ItineraryHotel
            {
                ItineraryId = itineraryId,
                HotelId = request.HotelId
            };

            await _unitOfWork.ItineraryHotels.AddAsync(itineraryHotel);
            await _unitOfWork.SaveChangesAsync();
        }
    }
}

using AutoMapper;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryService(IUnitOfWork _unitOfWork, IMapper _mapper) : IItineraryService
    {


        public async Task<IEnumerable<ItineraryDto>> GetAllItinerariesByUserIdAsync(int userId)
        {
            var itineraries = await _unitOfWork.Itineraries.GetAllAsync(i => i.UserId == userId && !i.DeleteFlag, includeProperties: "StartProvince,DestinationProvince");

            return _mapper.Map<IEnumerable<ItineraryDto>>(itineraries);
        }

        public Task<ItineraryDto> GetItineraryByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        public async Task<ItineraryDto> CreateItineraryAsync(int userId, CreateItineraryRequestDto request)
        {
            // create itinerary
            var itinerary = new Itinerary
            {
                UserId = userId,
                StartProvinceId = request.StartProvinceId,
                DestinationProvinceId = request.DestinationProvinceId,
                Name = request.Name,
                StartDate = request.StartDate,
                EndDate = request.EndDate,
                DeleteFlag = false
            };

            await _unitOfWork.Itineraries.AddAsync(itinerary);
            await _unitOfWork.SaveChangesAsync();

            return _mapper.Map<ItineraryDto>(itinerary);
        }
    }
}

using AutoMapper;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
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

        public async Task<CreateItineraryResponseDto> CreateItineraryAsync(int userId, CreateItineraryRequestDto request)
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
                DaysCount = (request.EndDate - request.StartDate).Days + 1,
                GroupSize = 1, // default group size
                DeleteFlag = false
            };

            await _unitOfWork.Itineraries.AddAsync(itinerary);
            await _unitOfWork.SaveChangesAsync();

            // add default itinerary days
            var days = new List<ItineraryDay>();
            for (int day = 1; day <= itinerary.DaysCount; day++)
            {
                var itineraryDay = new ItineraryDay
                {
                    ItineraryId = itinerary.Id,
                    DayNumber = day,
                    Date = itinerary.StartDate.AddDays(day - 1)
                };
                days.Add(itineraryDay);
            }
            await _unitOfWork.ItineraryDays.AddRangeAsync(days);
            await _unitOfWork.SaveChangesAsync();

            // add default budget
            var budget = new Budget
            {
                ItineraryId = itinerary.Id,
                TotalBudget = 0 // default budget amount
            };
            await _unitOfWork.Budgets.AddAsync(budget);
            await _unitOfWork.SaveChangesAsync();

            return new CreateItineraryResponseDto { Id = itinerary.Id };
        }
    }

}

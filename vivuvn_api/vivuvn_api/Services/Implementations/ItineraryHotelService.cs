using AutoMapper;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryHotelService(IUnitOfWork _unitOfWork,
        IGoogleMapPlaceService _placeService,
        IMapper _mapper, IJsonService _jsonService) : IitineraryHotelService
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

        public async Task AddHotelToItineraryFromSearchAsync(int itineraryId, AddHotelToItineraryFromSearch request)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new BadHttpRequestException("Itinerary not found");

            var hotel = await _unitOfWork.Hotels.GetOneAsync(h => h.GooglePlaceId == request.GooglePlaceId);

            // if hotel exists in db, use it
            if (hotel != null)
            {
                await _unitOfWork.ItineraryHotels.AddAsync(new ItineraryHotel
                {
                    ItineraryId = itineraryId,
                    HotelId = hotel.Id,
                    CheckIn = request.CheckIn,
                    CheckOut = request.CheckOut
                });
                await _unitOfWork.SaveChangesAsync();
                return;
            }

            // else, fetch from google place api and add to db
            var place = await _placeService.FetchPlaceDetailsByIdAsync(request.GooglePlaceId)
                ?? throw new BadHttpRequestException("Fail to add hotel. Cannot find hotel data");

            var hotelDto = _mapper.Map<HotelDto>(place);

            var newHotel = _mapper.Map<Hotel>(hotelDto);

            await _unitOfWork.Hotels.AddAsync(newHotel);
            await _unitOfWork.SaveChangesAsync();

            var itineraryHotel = new ItineraryHotel
            {
                ItineraryId = itineraryId,
                HotelId = newHotel.Id,
                CheckIn = request.CheckIn,
                CheckOut = request.CheckOut
            };
            await _unitOfWork.ItineraryHotels.AddAsync(itineraryHotel);
            await _unitOfWork.SaveChangesAsync();

            // save hotel data to json file for caching
            await _jsonService.SaveSingleHotelToJsonFile(newHotel);
        }

        public async Task UpdateNotesAsync(int itineraryId, int itineraryHotelId, string notes)
        {
            var itineraryHotel = await _unitOfWork.ItineraryHotels.GetOneAsync(ih => ih.Id == itineraryHotelId && ih.ItineraryId == itineraryId)
                ?? throw new BadHttpRequestException("Itinerary hotel not found");
            itineraryHotel.Notes = notes;
            _unitOfWork.ItineraryHotels.Update(itineraryHotel);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task UpdateCheckInCheckOutAsync(int itineraryId, int itineraryHotelId, DateOnly checkIn, DateOnly checkOut)
        {
            var itineraryHotel = await _unitOfWork.ItineraryHotels
                .GetOneAsync(ih => ih.Id == itineraryHotelId && ih.ItineraryId == itineraryId)
                ?? throw new BadHttpRequestException("Itinerary hotel not found");
            
            itineraryHotel.CheckIn = checkIn;
            itineraryHotel.CheckOut = checkOut;
            _unitOfWork.ItineraryHotels.Update(itineraryHotel);
            await _unitOfWork.SaveChangesAsync();
        }
    }
}

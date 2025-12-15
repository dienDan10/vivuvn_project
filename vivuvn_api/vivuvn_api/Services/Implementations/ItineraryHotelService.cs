using AutoMapper;
using Microsoft.EntityFrameworkCore;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryHotelService(IUnitOfWork _unitOfWork, IGoogleMapPlaceService _placeService, IMapper _mapper) : IitineraryHotelService
    {
        public async Task<IEnumerable<ItineraryHotelDto>> GetHotelsInItineraryAsync(int itineraryId)
        {
            return await _unitOfWork.ItineraryHotels
                .GetQueryable()
                .Where(ih => ih.ItineraryId == itineraryId)
                .OrderBy(ih => ih.CheckIn)
                .Select(ih => new ItineraryHotelDto
                {
                    Id = ih.Id,
                    HotelId = ih.HotelId,
                    Cost = ih.BudgetItem != null ? ih.BudgetItem.Cost : 0,
                    CheckIn = ih.CheckIn ?? default,
                    CheckOut = ih.CheckOut ?? default,
                    Notes = ih.Notes,
                    Hotel = ih.Hotel != null ? new HotelDto
                    {
                        Id = ih.Hotel.Id,
                        GooglePlaceId = ih.Hotel.GooglePlaceId,
                        Name = ih.Hotel.Name,
                        Address = ih.Hotel.Address,
                        Rating = ih.Hotel.Rating,
                        UserRatingCount = ih.Hotel.UserRatingCount,
                        Latitude = ih.Hotel.Latitude,
                        Longitude = ih.Hotel.Longitude,
                        GoogleMapsUri = ih.Hotel.GoogleMapsUri,
                        PriceLevel = ih.Hotel.PriceLevel,
                        DeleteFlag = ih.Hotel.DeleteFlag,
                        Photos = ih.Hotel.Photos
                            .Select(p => p.PhotoUrl)
                            .ToList()
                    } : null
                })
                .AsNoTracking()
                .ToListAsync();
        }

        public async Task AddHotelToItineraryFromSuggestionAsync(int itineraryId, AddHotelToItineraryFromSuggestionDto request)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId)
                ?? throw new BadHttpRequestException("Không tìm thấy lịch trình");

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
                ?? throw new BadHttpRequestException("Không tìm thấy lịch trình");

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
                ?? throw new BadHttpRequestException("Không thể thêm khách sạn. Không tìm thấy dữ liệu khách sạn");

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
        }

        public async Task UpdateNotesAsync(int itineraryId, int itineraryHotelId, string notes)
        {
            var itineraryHotel = await _unitOfWork.ItineraryHotels.GetOneAsync(ih => ih.Id == itineraryHotelId && ih.ItineraryId == itineraryId)
                ?? throw new BadHttpRequestException("Không tìm thấy khách sạn trong lịch trình");
            itineraryHotel.Notes = notes;
            _unitOfWork.ItineraryHotels.Update(itineraryHotel);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task UpdateCheckInCheckOutAsync(int itineraryId, int itineraryHotelId, DateOnly checkIn, DateOnly checkOut)
        {
            var itineraryHotel = await _unitOfWork.ItineraryHotels
                .GetOneAsync(ih => ih.Id == itineraryHotelId && ih.ItineraryId == itineraryId)
                ?? throw new BadHttpRequestException("Không tìm thấy khách sạn trong lịch trình");

            itineraryHotel.CheckIn = checkIn;
            itineraryHotel.CheckOut = checkOut;
            _unitOfWork.ItineraryHotels.Update(itineraryHotel);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task UpdateCostAsync(int itineraryId, int itineraryHotelId, decimal cost)
        {
            var itineraryHotel = await _unitOfWork.ItineraryHotels
                .GetOneAsync(ih => ih.Id == itineraryHotelId && ih.ItineraryId == itineraryId, includeProperties: "BudgetItem,Hotel")
                ?? throw new BadHttpRequestException("Không tìm thấy khách sạn trong lịch trình");

            // if budget item exists, update cost
            if (itineraryHotel.BudgetItem != null)
            {
                itineraryHotel.BudgetItem.Cost = cost;
                await _unitOfWork.Budgets.UpdateBudgetItemAsync(itineraryHotel.BudgetItem);
                await _unitOfWork.SaveChangesAsync();
                return;
            }

            // else, create new budget item
            var budget = await _unitOfWork.Budgets
                .GetOneAsync(b => b.ItineraryId == itineraryId)
                ?? throw new BadHttpRequestException("Không tìm thấy ngân sách cho lịch trình này");

            var budgetType = await _unitOfWork.BudgetTypes
                .GetOneAsync(bt => bt.Name == Constants.BudgetType_Lodging)
                ?? throw new BadHttpRequestException("Không tìm thấy loại ngân sách 'Chỗ ở'");

            var budgetItem = new BudgetItem
            {
                Name = itineraryHotel.Hotel?.Name ?? "Lodging cost",
                BudgetId = budget.BudgetId,
                Cost = cost,
                Date = itineraryHotel.CheckIn.HasValue
                    ? itineraryHotel.CheckIn.Value.ToDateTime(new TimeOnly(0, 0))
                    : DateTime.UtcNow,
                BudgetTypeId = budgetType.BudgetTypeId
            };
            await _unitOfWork.Budgets.AddBudgetItemAsync(budgetItem);
            await _unitOfWork.SaveChangesAsync();

            itineraryHotel.BudgetItemId = budgetItem.Id;
            _unitOfWork.ItineraryHotels.Update(itineraryHotel);
            await _unitOfWork.SaveChangesAsync();
        }

        public async Task DeleteItineraryHotelAsync(int itineraryId, int itineraryHotelId)
        {
            var itineraryHotel = await _unitOfWork.ItineraryHotels
                .GetOneAsync(ih => ih.Id == itineraryHotelId && ih.ItineraryId == itineraryId,
                             includeProperties: "BudgetItem")
                ?? throw new BadHttpRequestException("Không tìm thấy khách sạn trong lịch trình");

            // Delete the related budget item if it exists
            if (itineraryHotel.BudgetItemId.HasValue)
            {
                await _unitOfWork.Budgets.DeleteBudgetItemAsync(itineraryHotel.BudgetItemId.Value);
            }

            // Delete the itinerary hotel
            _unitOfWork.ItineraryHotels.Remove(itineraryHotel);
            await _unitOfWork.SaveChangesAsync();
        }
    }
}

using AutoMapper;
using Microsoft.EntityFrameworkCore;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Extensions;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryService(IUnitOfWork _unitOfWork, IMapper _mapper, IAiClientService _aiClient, IGoogleMapRouteService _routeService, IItineraryMemberService _memberService) : IItineraryService
    {
        #region Itinerary Service Methods

        public async Task<IEnumerable<ItineraryDto>> GetAllItinerariesByUserIdAsync(int userId)
        {
            var itineraries = await _unitOfWork.Itineraries
                .GetQueryable()
                .Where(i => (i.UserId == userId
                            || i.Members.Any(m => m.UserId == userId && !m.DeleteFlag))
                            && !i.DeleteFlag)
                .Include(i => i.StartProvince)
                .Include(i => i.DestinationProvince)
                .Include(i => i.User)
                .AsNoTracking()
                .ToListAsync();

            return itineraries.Select(i =>
            {
                var dto = _mapper.Map<ItineraryDto>(i);
                dto.IsOwner = i.UserId == userId;
                return dto;
            });
        }

        public async Task<PaginatedResponseDto<SearchItineraryDto>> GetAllPublicItinerariesAsync(GetAllPublicItinerariesRequestDto request, int? currentUserId = null)
        {
            var query = _unitOfWork.Itineraries
                .GetQueryable()
                .Where(i => i.IsPublic && !i.DeleteFlag && i.StartDate > DateTime.UtcNow);

            if (request.ProvinceId.HasValue)
            {
                query = query.Where(i => i.StartProvinceId == request.ProvinceId
                                       || i.DestinationProvinceId == request.ProvinceId);
            }

            if (request.SortByDate ?? true)
            {
                query = (request.IsDescending ?? false)
                    ? query.OrderByDescending(i => i.StartDate)
                    : query.OrderBy(i => i.StartDate);
            }

            var totalCount = await query.CountAsync();

            var itineraryDtos = await query
                .Skip(((request.Page ?? 1) - 1) * (request.PageSize ?? Constants.DefaultPageSize))
                .Take(request.PageSize ?? Constants.DefaultPageSize)
                .Select(i => new SearchItineraryDto
                {
                    Id = i.Id,
                    Name = i.Name,
                    StartProvinceName = i.StartProvince.Name,
                    DestinationProvinceName = i.DestinationProvince.Name,
                    StartDate = i.StartDate,
                    EndDate = i.EndDate,
                    ImageUrl = i.DestinationProvince.ImageUrl,
                    GroupSize = i.GroupSize,
                    CurrentMemberCount = i.Members.Count(m => !m.DeleteFlag),
                    IsMember = currentUserId.HasValue &&
                               i.Members.Any(m => m.UserId == currentUserId.Value && !m.DeleteFlag),
                    Owner = new UserDto
                    {
                        Id = i.User.Id,
                        Username = i.User.Username,
                        Email = i.User.Email,
                        UserPhoto = i.User.UserPhoto
                    }
                })
                .AsNoTracking()
                .ToListAsync();

            return new PaginatedResponseDto<SearchItineraryDto>
            {
                Data = itineraryDtos,
                PageNumber = request.Page ?? 1,
                PageSize = request.PageSize ?? Constants.DefaultPageSize,
                TotalCount = totalCount,
                TotalPages = (int)Math.Ceiling(totalCount / (double)(request.PageSize ?? Constants.DefaultPageSize)),
                HasPreviousPage = (request.Page ?? 1) > 1,
                HasNextPage = (request.Page ?? 1) < (int)Math.Ceiling(totalCount / (double)(request.PageSize ?? Constants.DefaultPageSize))
            };
        }

        public async Task<int> CopyPublicItineraryAsync(int userId, CopyPublicItineraryRequestDto request)
        {
            // member cannot copy itinerary
            var isMember = await _memberService.IsMemberAsync(request.ItineraryId, userId);
            if (isMember) throw new BadHttpRequestException("Bạn không thể sao chép lịch trình nếu bạn là thành viên");

            var publicItinerary = await _unitOfWork.Itineraries
                .GetQueryable()
                .Where(i => i.Id == request.ItineraryId && i.IsPublic && !i.DeleteFlag)
                .Include(i => i.Days)
                    .ThenInclude(d => d.Items)
                .Include(i => i.FavoritePlaces)
                .Include(i => i.Restaurants)
                .Include(i => i.Hotels)
                .AsSplitQuery()
                .AsNoTracking()
                .FirstOrDefaultAsync();

            if (publicItinerary == null)
            {
                throw new KeyNotFoundException($"Không tìm thấy lịch trình công khai có ID {request.ItineraryId}.");
            }

            await _unitOfWork.BeginTransactionAsync();

            try
            {
                // Create new itinerary
                var newItinerary = new Itinerary
                {
                    UserId = userId,
                    StartProvinceId = publicItinerary.StartProvinceId,
                    DestinationProvinceId = publicItinerary.DestinationProvinceId,
                    Name = publicItinerary.Name,
                    StartDate = publicItinerary.StartDate,
                    EndDate = publicItinerary.EndDate,
                    DaysCount = (publicItinerary.EndDate - publicItinerary.StartDate).Days + 1,
                    TransportationVehicle = publicItinerary.TransportationVehicle,
                    GroupSize = 1,
                    IsPublic = false,
                    DeleteFlag = false,
                    Days = publicItinerary.Days
                        .OrderBy(d => d.DayNumber)
                        .Select(day => new ItineraryDay
                        {
                            DayNumber = day.DayNumber,
                            Date = publicItinerary.StartDate.AddDays(day.DayNumber - 1),
                            Items = day.Items.Select(item => new ItineraryItem
                            {
                                LocationId = item.LocationId,
                                OrderIndex = item.OrderIndex,
                                Note = item.Note,
                                EstimateDuration = item.EstimateDuration,
                                StartTime = item.StartTime,
                                EndTime = item.EndTime,
                                TransportationVehicle = item.TransportationVehicle,
                                TransportationDuration = item.TransportationDuration,
                                TransportationDistance = item.TransportationDistance
                            }).ToList()
                        }).ToList(),
                    FavoritePlaces = publicItinerary.FavoritePlaces
                        .Select(fp => new FavoritePlace
                        {
                            LocationId = fp.LocationId
                        }).ToList(),
                    Hotels = publicItinerary.Hotels
                        .Select(h => new ItineraryHotel
                        {
                            HotelId = h.HotelId,
                            CheckIn = h.CheckIn,
                            CheckOut = h.CheckOut,
                            Notes = h.Notes,
                        }).ToList(),
                    Restaurants = publicItinerary.Restaurants
                        .Select(r => new ItineraryRestaurant
                        {
                            RestaurantId = r.RestaurantId,
                            Date = r.Date,
                            Time = r.Time,
                            Notes = r.Notes,
                        }).ToList(),
                    Budget = new Budget
                    {
                        EstimatedBudget = 0,
                        TotalBudget = 0
                    },
                    Members = new List<ItineraryMember>
                    {
                        new ItineraryMember
                        {
                            UserId = userId,
                            JoinedAt = DateTime.UtcNow,
                            Role = Constants.ItineraryRole_Owner
                        }
                    }
                };

                await _unitOfWork.Itineraries.AddAsync(newItinerary);

                await _unitOfWork.SaveChangesAsync();

                await _unitOfWork.CommitTransactionAsync();

                return newItinerary.Id;
            }
            catch (Exception)
            {
                await _unitOfWork.RollbackTransactionAsync();
                throw;
            }
        }
        public async Task<ItineraryDto> GetItineraryByIdAsync(int id, int userId)
        {
            var result = await _unitOfWork.Itineraries
                .GetQueryable()
                .Where(i => i.Id == id && !i.DeleteFlag)
                .Include(i => i.StartProvince)
                .Include(i => i.DestinationProvince)
                .Include(i => i.User)
                .Select(i => new
                {
                    Itinerary = i,
                    IsOwner = i.UserId == userId,
                    IsMember = i.Members.Any(m => m.UserId == userId && !m.DeleteFlag)
                })
                .AsNoTracking()
                .FirstOrDefaultAsync();

            if (result == null)
                throw new KeyNotFoundException($"Không tìm thấy lịch trình có ID {id}.");

            var dto = _mapper.Map<ItineraryDto>(result.Itinerary);
            dto.IsOwner = result.IsOwner;
            dto.IsMember = result.IsMember;
            return dto;
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

            // add default budget
            var budget = new Budget
            {
                ItineraryId = itinerary.Id,
                EstimatedBudget = 0, // default estimated budget
                TotalBudget = 0 // default budget amount
            };
            await _unitOfWork.Budgets.AddAsync(budget);

            // add owner as member
            var member = new ItineraryMember
            {
                ItineraryId = itinerary.Id,
                UserId = userId,
                JoinedAt = DateTime.UtcNow,
                Role = Constants.ItineraryRole_Owner
            };
            await _unitOfWork.ItineraryMembers.AddAsync(member);

            await _unitOfWork.SaveChangesAsync();
            return new CreateItineraryResponseDto { Id = itinerary.Id };
        }

        public async Task<bool> DeleteItineraryByIdAsync(int id)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == id && !i.DeleteFlag);
            if (itinerary == null) return false;
            itinerary.DeleteFlag = true;
            _unitOfWork.Itineraries.Update(itinerary);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task UpdateItineraryDatesAsync(int itineraryId, UpdateItineraryDatesRequestDto request)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId && !i.DeleteFlag);

            if (itinerary == null)
            {
                throw new KeyNotFoundException($"Không tìm thấy lịch trình có ID {itineraryId}.");
            }

            itinerary.StartDate = request.StartDate;
            itinerary.EndDate = request.EndDate;
            itinerary.DaysCount = (request.EndDate - request.StartDate).Days + 1;
            _unitOfWork.Itineraries.Update(itinerary);
            await _unitOfWork.SaveChangesAsync();

            // Update itinerary days
            var days = await _unitOfWork.ItineraryDays.GetAllAsync(d => d.ItineraryId == itineraryId);
            foreach (var day in days)
            {
                day.Date = itinerary.StartDate.AddDays(day.DayNumber - 1);
                _unitOfWork.ItineraryDays.Update(day);
            }

            // days < itinerary.DaysCount: add new days
            if (days.Count() < itinerary.DaysCount)
            {
                for (int dayNumber = days.Count() + 1; dayNumber <= itinerary.DaysCount; dayNumber++)
                {
                    var newDay = new ItineraryDay
                    {
                        ItineraryId = itinerary.Id,
                        DayNumber = dayNumber,
                        Date = itinerary.StartDate.AddDays(dayNumber - 1)
                    };
                    await _unitOfWork.ItineraryDays.AddAsync(newDay);
                }
            }
            // days > itinerary.DaysCount: remove extra days
            else if (days.Count() > itinerary.DaysCount)
            {
                var daysToRemove = days.Where(d => d.DayNumber > itinerary.DaysCount).ToList();
                foreach (var dayToRemove in daysToRemove)
                {
                    _unitOfWork.ItineraryDays.Remove(dayToRemove);
                }
            }

            await _unitOfWork.SaveChangesAsync();
        }

        public async Task<bool> UpdateItineraryNameAsync(int itineraryId, string newName)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId && !i.DeleteFlag);
            if (itinerary == null)
            {
                return false;
            }
            itinerary.Name = newName;
            _unitOfWork.Itineraries.Update(itinerary);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UpdateItineraryGroupSizeAsync(int itineraryId, int newGroupSize)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId && !i.DeleteFlag);
            if (itinerary == null)
            {
                return false;
            }
            itinerary.GroupSize = newGroupSize;
            _unitOfWork.Itineraries.Update(itinerary);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<bool> SetItineraryToPublicAsync(int itineraryId)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId && !i.DeleteFlag);
            if (itinerary == null)
            {
                return false;
            }
            itinerary.IsPublic = true;
            _unitOfWork.Itineraries.Update(itinerary);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<bool> SetItineraryToPrivateAsync(int itineraryId)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId && !i.DeleteFlag);
            if (itinerary == null)
            {
                return false;
            }
            itinerary.IsPublic = false;
            _unitOfWork.Itineraries.Update(itinerary);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UpdateItineraryTransportationAsync(int itineraryId, TransportationMode transportation)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId && !i.DeleteFlag);
            if (itinerary == null)
            {
                return false;
            }
            itinerary.TransportationVehicle = TransportationModeExtensions.ToVietnameseString(transportation);
            _unitOfWork.Itineraries.Update(itinerary);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        #endregion

        #region Itinerary Schedule Methods

        public async Task<IEnumerable<ItineraryDayDto>> GetItineraryScheduleAsync(int itineraryId)
        {

            return await _unitOfWork.ItineraryDays
                .GetQueryable()
                .Where(d => d.ItineraryId == itineraryId)
                .OrderBy(d => d.DayNumber)
                .Select(d => new ItineraryDayDto
                {
                    Id = d.Id,
                    DayNumber = d.DayNumber,
                    Date = d.Date,
                    Items = d.Items
                        .OrderBy(i => i.OrderIndex)
                        .Select(i => new ItineraryItemDto
                        {
                            ItineraryItemId = i.ItineraryItemId,
                            OrderIndex = i.OrderIndex,
                            Note = i.Note,
                            EstimateDuration = i.EstimateDuration,
                            StartTime = i.StartTime,
                            EndTime = i.EndTime,
                            TransportationVehicle = i.TransportationVehicle,
                            TransportationDuration = i.TransportationDuration,
                            TransportationDistance = i.TransportationDistance,
                            Location = new LocationDto
                            {
                                Id = i.Location.Id,
                                Name = i.Location.Name,
                                ProvinceName = i.Location.Province.Name,
                                Description = i.Location.Description,
                                Latitude = i.Location.Latitude,
                                Longitude = i.Location.Longitude,
                                Address = i.Location.Address,
                                Rating = i.Location.Rating,
                                RatingCount = i.Location.RatingCount,
                                GooglePlaceId = i.Location.GooglePlaceId,
                                PlaceUri = i.Location.PlaceUri,
                                DirectionsUri = i.Location.DirectionsUri,
                                ReviewUri = i.Location.ReviewUri,
                                WebsiteUri = i.Location.WebsiteUri,
                                DeleteFlag = i.Location.DeleteFlag,
                                Photos = i.Location.Photos
                                    .Select(p => p.PhotoUrl)
                                    .ToList()
                            }
                        })
                        .ToList()
                })
                .AsNoTracking()
                .ToListAsync();
        }

        #endregion

        #region Itinerary Auto-Generation Methods

        public async Task<AutoGenerateItineraryResponseDto> AutoGenerateItineraryAsync(int itineraryId, AutoGenerateItineraryRequest request)
        {
            // Retrieve and return the complete itinerary with all details
            var itinerary = await _unitOfWork.Itineraries
                .GetQueryable()
                .Where(i => i.Id == itineraryId)
                .Include(i => i.StartProvince)
                .Include(i => i.DestinationProvince)
                .Include(i => i.Days.OrderBy(d => d.DayNumber))
                    .ThenInclude(d => d.Items)
                .Include(i => i.Budget)
                    .ThenInclude(b => b.Items)
                        .ThenInclude(bi => bi.ItineraryHotel)
                .Include(i => i.Budget)
                    .ThenInclude(b => b.Items)
                        .ThenInclude(bi => bi.ItineraryRestaurant)
                .AsSplitQuery()
                .AsTracking()
                .FirstOrDefaultAsync()
                ?? throw new KeyNotFoundException($"Không tìm thấy lịch trình có ID {itineraryId}.");

            var daysCount = (itinerary.EndDate - itinerary.StartDate).Days + 1;
            if (daysCount > 10 || daysCount < 1)
            {
                throw new ArgumentException("Tự động tạo lịch trình chỉ hỗ trợ từ 1 đến 10 ngày.");
            }

            // Generate itinerary from AI service
            var aiRequest = new AITravelItineraryGenerateRequest()
            {
                Origin = itinerary.StartProvince.Name,
                Destination = itinerary.DestinationProvince.Name,
                StartDate = itinerary.StartDate.Date,
                EndDate = itinerary.EndDate.Date,
                Preferences = request.Preferences,
                GroupSize = request.GroupSize,
                Budget = request.Budget,
                SpecialRequirements = request.SpecialRequirements,
                TransportationMode = request.TransportationMode
            };

            var aiResponse = await _aiClient.GenerateItineraryAsync<AutoGenerateItineraryResponse>(aiRequest);

            if (aiResponse?.Itinerary == null)
            {
                throw new InvalidOperationException("Không thể tạo lịch trình từ dịch vụ AI.");
            }

            // Save the generated itinerary to database
            var savedItinerary = await SaveTravelItineraryToDatabaseAsync(itinerary, aiResponse.Itinerary, request.GroupSize, request.Budget!.Value);

            return new AutoGenerateItineraryResponseDto
            {
                Status = aiResponse.Itinerary.ScheduleUnavailable
                    ? Constants.ResponseStatus_Warning
                    : Constants.ResponseStatus_Success,
                ItineraryId = savedItinerary.Id,
                Warnings = aiResponse.Itinerary.Warnings,
                Message = "Lịch trình đã được tạo thành công."
            };
        }

        private async Task<Itinerary> SaveTravelItineraryToDatabaseAsync(Itinerary itinerary, TravelItinerary travelItinerary, int groupSize, long estimatedBudget)
        {
            try
            {
                await _unitOfWork.BeginTransactionAsync();

                // Update itinerary group size
                itinerary.GroupSize = groupSize;

                // Update transportation vehicle
                itinerary.TransportationVehicle = travelItinerary.TransportationSuggestions
                    .FirstOrDefault()?.Mode ?? null;

                // Update estimated budget
                itinerary.Budget!.EstimatedBudget = estimatedBudget;

                // UPDATE ITINERARY DAYS AND ITEMS
                await ProcessItineraryDaysAsync(travelItinerary.Days, itinerary.Days, travelItinerary);

                // UPDATE BUDGET ITEMS
                await ProcessItineraryBudgetAsync(itinerary, travelItinerary);

                // UPDATE TRANSPORTATION SUGGESTIONS AND BUDGET ITEMS
                await ProcessTransportationSuggestionsAsync(travelItinerary.TransportationSuggestions, itinerary.Budget);

                // Update budget total if TotalCost is provided
                if (travelItinerary.TotalCost > 0)
                {
                    itinerary.Budget.TotalBudget += travelItinerary.TotalCost;
                }

                // Single SaveChanges at the end for all changes
                await _unitOfWork.SaveChangesAsync();
                await _unitOfWork.CommitTransactionAsync();

                return itinerary;
            }
            catch (Exception)
            {
                await _unitOfWork.RollbackTransactionAsync();
                throw new BadHttpRequestException("Đã có lỗi xảy ra khi tạo lịch trình");
            }
        }

        private async Task ProcessItineraryDaysAsync(
            List<AIDayItineraryDto> aiDays,
            ICollection<ItineraryDay> existingDays
            , TravelItinerary travelItinerary)
        {
            // Clear existing itinerary items from all days
            foreach (var day in existingDays)
            {
                if (day.Items != null && day.Items.Any())
                {
                    day.Items.Clear();
                }
            }

            // get all locations corresponding to PlaceIds in the itinerary
            var allPlaceIds = travelItinerary.Days
                    .SelectMany(d => d.Activities)
                    .Select(a => a.PlaceId)
                    .Where(placeId => !string.IsNullOrEmpty(placeId))
                    .Distinct()
                    .ToList();

            var locations = await _unitOfWork.Locations.GetAllAsync(
                l => !string.IsNullOrEmpty(l.GooglePlaceId) && allPlaceIds.Contains(l.GooglePlaceId) && !l.DeleteFlag);

            var locationDict = locations
                .Where(l => !string.IsNullOrEmpty(l.GooglePlaceId))
                .GroupBy(l => l.GooglePlaceId!)
                .ToDictionary(g => g.Key, g => g.First());

            var locationByIdDict = locations.ToDictionary(l => l.Id);

            // add activities to each day
            foreach (var aiDay in aiDays)
            {
                // Find or create the itinerary day
                var existingDay = existingDays.FirstOrDefault(d => d.DayNumber == aiDay.Day);

                // Process activities for this day
                int orderIndex = 1;
                var items = new List<ItineraryItem>();

                foreach (var activity in aiDay.Activities)
                {
                    // Look up the location from the pre-loaded dictionary
                    if (!locationDict.TryGetValue(activity.PlaceId, out var location))
                    {
                        throw new KeyNotFoundException($"Không tìm thấy địa điểm có PlaceId {activity.PlaceId} trong cơ sở dữ liệu.");
                    }

                    // Create itinerary item
                    var itineraryItem = _mapper.Map<ItineraryItem>(activity);
                    itineraryItem.ItineraryDayId = existingDay.Id;
                    itineraryItem.LocationId = location.Id;
                    itineraryItem.OrderIndex = orderIndex++;
                    itineraryItem.TransportationVehicle = Constants.TravelMode_Driving;
                    itineraryItem.TransportationDuration = 500;
                    itineraryItem.TransportationDistance = 278;
                    itineraryItem.StartTime = activity.Time;
                    itineraryItem.EndTime = activity.Time.AddHours(activity.DurationHours);

                    items.Add(itineraryItem);
                }

                for (int i = 1; i < items.Count; i++)
                {
                    try
                    {
                        await UpdateTransportationDetailsAsync(items[i - 1], items[i], locationByIdDict);
                    }
                    catch
                    {
                        // ignore errors
                    }
                }

                // add items to the existing day
                foreach (var item in items)
                {
                    existingDay.Items.Add(item);
                }
                //await _unitOfWork.SaveChangesAsync();
            }

        }

        private async Task UpdateTransportationDetailsAsync(ItineraryItem prevItem,
            ItineraryItem curItem,
            Dictionary<int, Location> locationDict,
            string? travelMode = Constants.TravelMode_Driving)
        {
            if (!locationDict.TryGetValue(prevItem.LocationId ?? 0, out var prevItemLocation))
            {
                throw new KeyNotFoundException($"Location {prevItem.LocationId} not found");
            }

            if (!locationDict.TryGetValue(curItem.LocationId ?? 0, out var curItemLocation))
            {
                throw new KeyNotFoundException($"Location {curItem.LocationId} not found");
            }

            var request = new ComputeRouteRequestDto
            {
                Origin = new OriginDestination
                {
                    PlaceId = prevItemLocation?.GooglePlaceId
                },
                Destination = new OriginDestination
                {
                    PlaceId = curItemLocation?.GooglePlaceId
                },
                TravelMode = travelMode ?? Constants.TravelMode_Driving,
            };

            var response = await _routeService.GetRouteInformationAsync(request);

            if (response is null || response.Routes is null || !response.Routes.Any()) throw new BadHttpRequestException("Không thể lấy thông tin tuyến đường.");

            curItem.TransportationDistance = response.Routes?.FirstOrDefault()?.DistanceMeters ?? 500;
            curItem.TransportationVehicle = travelMode ?? Constants.TravelMode_Driving;

            _ = double.TryParse(response.Routes?.FirstOrDefault()?.Duration.Replace("s", ""), out double durationInSeconds);

            curItem.TransportationDuration = durationInSeconds;
        }

        private async Task ProcessItineraryBudgetAsync(Itinerary itinerary, TravelItinerary travelItinerary)
        {
            var budget = itinerary.Budget;

            if (budget?.Items != null)
            {
                // Clear all items that do not have ItineraryRestaurant and ItineraryHotel from the collection
                budget.Items = budget.Items
                    .Where(bi => bi.ItineraryHotel != null || bi.ItineraryRestaurant != null)
                    .ToList();
                budget.TotalBudget = budget.Items.Sum(bi => bi.Cost);
            }

            var activityBudgetType = await _unitOfWork.BudgetTypes
                .GetOneAsync(bt => bt.Name == Constants.BudgetType_Activities);
            foreach (var aiDay in travelItinerary.Days)
            {
                foreach (var activity in aiDay.Activities)
                {
                    if (activity.CostEstimate > 0)
                    {
                        var budgetItem = new BudgetItem
                        {
                            BudgetId = budget.BudgetId,
                            Name = activity.Name,
                            Cost = activity.CostEstimate,
                            Date = aiDay.Date,
                            BudgetTypeId = activityBudgetType!.BudgetTypeId
                        };
                        budget.Items.Add(budgetItem);
                    }
                }
            }
        }

        private async Task ProcessTransportationSuggestionsAsync(
            List<AITransportationSuggestionDto> transportations,
            Budget budget)
        {
            if (!transportations.Any()) return;

            var budgetTypeNames = new[]
            {
                Constants.BudgetType_Flights,
                Constants.BudgetType_Transit,
                Constants.BudgetType_Gas
            };

            var budgetTypes = await _unitOfWork.BudgetTypes
                .GetAllAsync(bt => budgetTypeNames.Contains(bt.Name));

            var budgetTypeDict = budgetTypes.ToDictionary(bt => bt.Name, bt => bt);

            foreach (var transportation in transportations)
            {
                if (transportation.EstimatedCost > 0)
                {
                    var budgetTypeName = transportation.Mode switch
                    {
                        var m when m.Equals(Constants.TransportationMode_Airplane, StringComparison.OrdinalIgnoreCase)
                            => Constants.BudgetType_Flights,
                        var m when m.Equals(Constants.TransportationMode_Bus, StringComparison.OrdinalIgnoreCase)
                            || m.Equals(Constants.TransportationMode_Train, StringComparison.OrdinalIgnoreCase)
                            => Constants.BudgetType_Transit,
                        var m when m.Equals(Constants.TransportationMode_PrivateCar, StringComparison.OrdinalIgnoreCase)
                            => Constants.BudgetType_Gas,
                        _ => Constants.BudgetType_Transit,
                    };

                    if (budgetTypeDict.TryGetValue(budgetTypeName, out var budgetType))
                    {
                        var budgetItem = new BudgetItem
                        {
                            BudgetId = budget.BudgetId,
                            Name = transportation.Mode,
                            Cost = transportation.EstimatedCost,
                            Date = transportation.Date,
                            BudgetTypeId = budgetType.BudgetTypeId,
                            Details = transportation.Details
                        };
                        budget.Items.Add(budgetItem);
                    }
                }
            }
        }
        #endregion
    }

}

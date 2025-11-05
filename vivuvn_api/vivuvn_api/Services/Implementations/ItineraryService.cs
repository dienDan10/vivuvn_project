using AutoMapper;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Helpers;
using vivuvn_api.Models;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
    public class ItineraryService(IUnitOfWork _unitOfWork, IMapper _mapper, IAiClientService _aiClient) : IItineraryService
    {
        #region Itinerary Service Methods

        public async Task<IEnumerable<ItineraryDto>> GetAllItinerariesByUserIdAsync(int userId)
        {
            var itineraries = await _unitOfWork.Itineraries
                .GetAllAsync(i => (i.UserId == userId || i.Members.Any(i => i.UserId == userId)) && !i.DeleteFlag, includeProperties: "StartProvince,DestinationProvince,User");

            var itineraryDtos = _mapper.Map<IEnumerable<ItineraryDto>>(itineraries);
            foreach (var dto in itineraryDtos)
            {
                var itinerary = itineraries.First(i => i.Id == dto.Id);
                dto.IsOwner = itinerary.UserId == userId;
            }

            return itineraryDtos;
        }

        public async Task<ItineraryDto> GetItineraryByIdAsync(int id, int userId)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == id && !i.DeleteFlag,
                includeProperties: "StartProvince,DestinationProvince,User");

            if (itinerary == null) throw new KeyNotFoundException($"Itinerary with id {id} not found.");
            var dto = _mapper.Map<ItineraryDto>(itinerary);
            dto.IsOwner = itinerary.UserId == userId;
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
                throw new KeyNotFoundException($"Itinerary with id {itineraryId} not found.");
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

        #endregion

        #region Itinerary Schedule Methods

        public async Task<IEnumerable<ItineraryDayDto>> GetItineraryScheduleAsync(int itineraryId)
        {
            var days = await _unitOfWork.ItineraryDays.GetAllAsync(d => d.ItineraryId == itineraryId,
                includeProperties: "Items,Items.Location,Items.Location.Photos,Items.Location.Province");

            if (days is null) return [];
            return _mapper.Map<IEnumerable<ItineraryDayDto>>(days);
        }

        #endregion

        public async Task<ItineraryDto> AutoGenerateItineraryAsync(int itineraryId, AutoGenerateItineraryRequest request)
        {
            // Retrieve and return the complete itinerary with all details
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId,
                includeProperties: "StartProvince,DestinationProvince");

            if (itinerary == null)
            {
                throw new KeyNotFoundException($"Itinerary with id {itineraryId} not found.");
            }

            var daysCount = (itinerary.EndDate - itinerary.StartDate).Days + 1;
            if (daysCount > 10 || daysCount < 1)
            {
                throw new ArgumentException("Auto-generation is only supported for itineraries from 1 to 10 days.");
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
                throw new InvalidOperationException("Failed to generate itinerary from AI service.");
            }

            if (aiResponse.Itinerary.ScheduleUnavailable)
            {
                throw new ArgumentException(aiResponse.Itinerary.UnavailableReason);
            }

            // Save the generated itinerary to database
            var savedItinerary = await SaveTravelItineraryToDatabaseAsync(itineraryId, aiResponse.Itinerary, request.GroupSize);

            // Map the saved entity directly to DTO (avoiding redundant query)
            var itineraryDto = _mapper.Map<ItineraryDto>(savedItinerary);

            return itineraryDto;
        }

        private async Task<Itinerary> SaveTravelItineraryToDatabaseAsync(int itineraryId, TravelItinerary travelItinerary, int groupSize)
        {
            try
            {
                await _unitOfWork.BeginTransactionAsync();

                // Get the existing itinerary with its days and budget
                var itinerary = await _unitOfWork.Itineraries.GetOneAsync(
                    i => i.Id == itineraryId,
                    includeProperties: "Days,Days.Items,Budget,Budget.Items,StartProvince,DestinationProvince",
                    tracked: true);

                if (itinerary == null)
                {
                    throw new KeyNotFoundException($"Itinerary with id {itineraryId} not found.");
                }

                // Update itinerary group size
                itinerary.GroupSize = groupSize;

				// Update transportation vehicle
                itinerary.TransportationVehicle = travelItinerary.TransportationSuggestions
                    .FirstOrDefault()?.Mode ?? null;

				// Use the budget from the navigation property
				var budget = itinerary.Budget;

                // Clear existing itinerary items from all days
                foreach (var day in itinerary.Days)
                {
                    if (day.Items != null && day.Items.Any())
                    {
                        foreach (var item in day.Items.ToList())
                        {
                            _unitOfWork.ItineraryItems.Remove(item);
                        }
                    }
                }

                if (budget?.Items != null)
                {
                    // Clear all items from the collection
                    budget.Items.Clear();
                    budget.TotalBudget = 0;
                }

                // Batch load all locations
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
                    .ToDictionary(l => l.GooglePlaceId!, l => l);

                // Get all budget types
                var allBudgetTypes = await _unitOfWork.Budgets.GetAllBudgetTypesAsync();
                var budgetTypeDict = allBudgetTypes.ToDictionary(bt => bt.Name, bt => bt.BudgetTypeId);

                // Process each day from the AI-generated itinerary
                await ProcessItineraryDaysAsync(itineraryId, travelItinerary.Days, budget, budgetTypeDict, itinerary.Days, locationDict);

                // Process transportation suggestions (no SaveChanges)
                await ProcessTransportationSuggestionsAsync(travelItinerary.TransportationSuggestions, budget, budgetTypeDict);

                // Update budget total if TotalCost is provided
                if (travelItinerary.TotalCost > 0 && budget != null)
                {
                    budget.TotalBudget = travelItinerary.TotalCost;
                }

                // Single SaveChanges at the end for all changes
                await _unitOfWork.SaveChangesAsync();
                await _unitOfWork.CommitTransactionAsync();

                return itinerary;
            }
            catch (Exception)
            {
                await _unitOfWork.RollbackTransactionAsync();
                throw;
            }
        }

        /// <summary>
        /// Processes all itinerary days and their activities
        /// </summary>
        private async Task ProcessItineraryDaysAsync(
            int itineraryId,
            List<AIDayItineraryDto> aiDays,
            Budget? budget,
            Dictionary<string, int> budgetTypeDict,
            ICollection<ItineraryDay> existingDays,
            Dictionary<string, Location> locationDict)
        {
            foreach (var aiDay in aiDays)
            {
                // Find or create the itinerary day
                var existingDay = existingDays.FirstOrDefault(d => d.DayNumber == aiDay.Day);

                // Process activities for this day
                int orderIndex = 1;

                foreach (var activity in aiDay.Activities)
                {
                    // Look up the location from the pre-loaded dictionary
                    if (!locationDict.TryGetValue(activity.PlaceId, out var location))
                    {
                        throw new KeyNotFoundException($"Location with PlaceId {activity.PlaceId} not found in database.");
                    }

                    // Create itinerary item
                    var itineraryItem = _mapper.Map<ItineraryItem>(activity);
                    itineraryItem.ItineraryDayId = existingDay.Id;
                    itineraryItem.LocationId = location.Id;
                    itineraryItem.OrderIndex = orderIndex++;
                    itineraryItem.TransportationVehicle = Constants.TravelMode_Driving;
                    itineraryItem.TransportationDuration = 500;
                    itineraryItem.TransportationDistance = 278;

                    await _unitOfWork.ItineraryItems.AddAsync(itineraryItem);

                    // Create budget item if activity has cost
                    if (activity.CostEstimate > 0 && budget != null)
                    {
                        var activityBudgetTypeId = budgetTypeDict.GetValueOrDefault(Constants.BudgetType_Activities);

                        if (activityBudgetTypeId > 0)
                        {
                            var budgetItem = new BudgetItem
                            {
                                BudgetId = budget.BudgetId,
                                Name = activity.Name,
                                Cost = activity.CostEstimate,
                                Date = aiDay.Date,
                                BudgetTypeId = activityBudgetTypeId
                            };
                            budget.Items.Add(budgetItem);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Processes transportation suggestions and creates budget items
        /// </summary>
        private async Task ProcessTransportationSuggestionsAsync(
            List<AITransportationSuggestionDto> transportations,
            Budget? budget,
            Dictionary<string, int> budgetTypeDict)
        {
            if (budget == null) return;

            foreach (var transportation in transportations)
            {
                if (transportation.EstimatedCost > 0)
                {
                    var transportationBudgetTypeId = transportation.Mode switch
                    {
                        var m when m.Equals(Constants.TransportationMode_Airplane, StringComparison.OrdinalIgnoreCase)
                            => budgetTypeDict.GetValueOrDefault(Constants.BudgetType_Flights),
                        var m when m.Equals(Constants.TransportationMode_Bus, StringComparison.OrdinalIgnoreCase)
                            || m.Equals(Constants.TransportationMode_Train, StringComparison.OrdinalIgnoreCase)
                            => budgetTypeDict.GetValueOrDefault(Constants.BudgetType_Transit),
                        var m when m.Equals(Constants.TransportationMode_PrivateCar, StringComparison.OrdinalIgnoreCase)
                            => budgetTypeDict.GetValueOrDefault(Constants.BudgetType_Gas),
                        _ => budgetTypeDict.GetValueOrDefault(Constants.BudgetType_Transit)
                    };

                    if (transportationBudgetTypeId > 0)
                    {
                        var budgetItem = new BudgetItem
                        {
                            BudgetId = budget.BudgetId,
                            Name = $"{transportation.Mode} - {transportation.Details}",
                            Cost = transportation.EstimatedCost,
                            Date = transportation.Date,
                            BudgetTypeId = transportationBudgetTypeId
                        };
                        budget.Items.Add(budgetItem);
                    }
                }
            }
        }
    }

}

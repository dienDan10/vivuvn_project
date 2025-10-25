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
            var itineraries = await _unitOfWork.Itineraries.GetAllAsync(i => i.UserId == userId && !i.DeleteFlag, includeProperties: "StartProvince,DestinationProvince");

            return _mapper.Map<IEnumerable<ItineraryDto>>(itineraries);
        }

        public async Task<ItineraryDto> GetItineraryByIdAsync(int id)
        {
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == id && !i.DeleteFlag,
                includeProperties: "StartProvince,DestinationProvince");

            if (itinerary == null) throw new KeyNotFoundException($"Itinerary with id {id} not found.");

            return _mapper.Map<ItineraryDto>(itinerary);
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
                EstimatedBudget = 0, // default estimated budget
                TotalBudget = 0 // default budget amount
            };
            await _unitOfWork.Budgets.AddAsync(budget);
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

        #endregion
        public async Task<IEnumerable<ItineraryDayDto>> GetItineraryScheduleAsync(int itineraryId)
        {
            var days = await _unitOfWork.ItineraryDays.GetAllAsync(d => d.ItineraryId == itineraryId,
                includeProperties: "Items,Items.Location,Items.Location.LocationPhotos,Items.Location.Province");

            if (days is null) return [];
            return _mapper.Map<IEnumerable<ItineraryDayDto>>(days);
        }

        public async Task<ItineraryDto> AutoGenerateItineraryAsync(int itineraryId, AutoGenerateItineraryRequest request)
        {
            // Retrieve and return the complete itinerary with all details
            var itinerary = await _unitOfWork.Itineraries.GetOneAsync(i => i.Id == itineraryId,
                includeProperties: "StartProvince,DestinationProvince");

            if (itinerary == null)
            {
                throw new KeyNotFoundException($"Itinerary with id {itineraryId} not found.");
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
            var savedSuccessfully = await SaveTravelItineraryToDatabaseAsync(itineraryId, aiResponse.Itinerary);

            if (!savedSuccessfully)
            {
                throw new InvalidOperationException("Failed to save generated itinerary to database.");
            }

            var itineraryDto = await GetItineraryByIdAsync(itineraryId);

            return itineraryDto;
        }

        /// <summary>
        /// Saves AI-generated travel itinerary to database (Private helper method)
        /// </summary>
        /// <param name="itineraryId">The ID of the existing itinerary to update</param>
        /// <param name="travelItinerary">The AI-generated travel itinerary data</param>
        /// <returns>True if successfully saved, false otherwise</returns>
        private async Task<bool> SaveTravelItineraryToDatabaseAsync(int itineraryId, TravelItinerary travelItinerary)
        {
            try
            {
                await _unitOfWork.BeginTransactionAsync();

                // Get the existing itinerary with its days
                var itinerary = await _unitOfWork.Itineraries.GetOneAsync(
                    i => i.Id == itineraryId,
                    includeProperties: "Days,Days.Items,Budget,Budget.Items");

                if (itinerary == null)
                {
                    throw new KeyNotFoundException($"Itinerary with id {itineraryId} not found.");
                }

                // Clear existing itinerary items from all days
                await ClearExistingItineraryItemsAsync(itinerary.Days);

                // Get budget and clear existing budget items
                var budget = await GetAndClearBudgetItemsAsync(itineraryId);

                // Get all budget types
                var allBudgetTypes = await _unitOfWork.Budgets.GetAllBudgetTypesAsync();
                var budgetTypeDict = allBudgetTypes.ToDictionary(bt => bt.Name, bt => bt.BudgetTypeId);

                // Process each day from the AI-generated itinerary
                await ProcessItineraryDaysAsync(itineraryId, travelItinerary.Days, budget, budgetTypeDict, itinerary.Days);

                // Process transportation suggestions
                await ProcessTransportationSuggestionsAsync(travelItinerary.TransportationSuggestions, budget, budgetTypeDict);

                // Update budget total if TotalCost is provided
                await UpdateBudgetTotalAsync(itineraryId, travelItinerary.TotalCost, budget);

                await _unitOfWork.SaveChangesAsync();
                await _unitOfWork.CommitTransactionAsync();

                return true;
            }
            catch (Exception)
            {
                await _unitOfWork.RollbackTransactionAsync();
                throw;
            }
        }

        /// <summary>
        /// Clears all existing itinerary items from the days
        /// </summary>
        private async Task ClearExistingItineraryItemsAsync(ICollection<ItineraryDay> days)
        {
            foreach (var day in days)
            {
                if (day.Items != null && day.Items.Any())
                {
                    foreach (var item in day.Items.ToList())
                    {
                        _unitOfWork.ItineraryItems.Remove(item);
                    }
                }
            }
            await _unitOfWork.SaveChangesAsync();
        }

        /// <summary>
        /// Gets the budget and clears all existing budget items
        /// </summary>
        private async Task<Budget?> GetAndClearBudgetItemsAsync(int itineraryId)
        {
            var budget = await _unitOfWork.Budgets.GetOneAsync(
                b => b.ItineraryId == itineraryId,
                includeProperties: "Items");

            if (budget != null && budget.Items != null && budget.Items.Any())
            {
                var existingBudgetItems = await _unitOfWork.Budgets.GetBudgetItemsByBudgetIdAsync(budget.BudgetId);
                foreach (var budgetItem in existingBudgetItems.ToList())
                {
                    await _unitOfWork.Budgets.DeleteBudgetItemAsync(budgetItem.Id);
                }
                await _unitOfWork.SaveChangesAsync();
            }

            return budget;
        }

        /// <summary>
        /// Processes all itinerary days and their activities
        /// </summary>
        private async Task ProcessItineraryDaysAsync(
            int itineraryId,
            List<AIDayItineraryDto> aiDays,
            Budget? budget,
            Dictionary<string, int> budgetTypeDict,
            ICollection<ItineraryDay> existingDays)
        {
            foreach (var aiDay in aiDays)
            {
                // Find or create the itinerary day
                var existingDay = existingDays.FirstOrDefault(d => d.DayNumber == aiDay.Day);

                if (existingDay == null)
                {
                    existingDay = new ItineraryDay
                    {
                        ItineraryId = itineraryId,
                        DayNumber = aiDay.Day,
                        Date = aiDay.Date
                    };
                    await _unitOfWork.ItineraryDays.AddAsync(existingDay);
                    await _unitOfWork.SaveChangesAsync();
                }

                // Process activities for this day
                await ProcessActivitiesForDayAsync(existingDay, aiDay.Activities, aiDay.Date, budget, budgetTypeDict);
            }
        }

        /// <summary>
        /// Processes all activities for a specific day
        /// </summary>
        private async Task ProcessActivitiesForDayAsync(
            ItineraryDay day,
            List<AIActivityDto> activities,
            DateTime date,
            Budget? budget,
            Dictionary<string, int> budgetTypeDict)
        {
            int orderIndex = 1;

            foreach (var activity in activities)
            {
                // Find the location by GooglePlaceId
                var location = await _unitOfWork.Locations.GetOneAsync(
                    l => l.GooglePlaceId == activity.PlaceId && !l.DeleteFlag);

                if (location == null)
                {
                    Console.WriteLine($"Warning: Location with PlaceId {activity.PlaceId} not found in database. Skipping activity: {activity.Name}");
                    continue;
                }

                // Create itinerary item
                var itineraryItem = _mapper.Map<ItineraryItem>(activity);
                itineraryItem.ItineraryDayId = day.Id;
                itineraryItem.LocationId = location.Id;
                itineraryItem.OrderIndex = orderIndex++;
                itineraryItem.TransportationVehicle = Constants.TravelMode_Driving;
                itineraryItem.TransportationDuration = 500;
                itineraryItem.TransportationDistance = 278;

                await _unitOfWork.ItineraryItems.AddAsync(itineraryItem);

                // Create budget item if activity has cost
                if (activity.CostEstimate > 0 && budget != null)
                {
                    await CreateActivityBudgetItemAsync(activity, budget, date, budgetTypeDict);
                }
            }
        }

        /// <summary>
        /// Creates a budget item for an activity
        /// </summary>
        private async Task CreateActivityBudgetItemAsync(
            AIActivityDto activity,
            Budget budget,
            DateTime date,
            Dictionary<string, int> budgetTypeDict)
        {
            var activityBudgetTypeId = budgetTypeDict.GetValueOrDefault(Constants.BudgetType_Activities);

            if (activityBudgetTypeId > 0)
            {
                var budgetItem = new BudgetItem
                {
                    BudgetId = budget.BudgetId,
                    Name = activity.Name,
                    Cost = activity.CostEstimate,
                    Date = date,
                    BudgetTypeId = activityBudgetTypeId
                };
                await _unitOfWork.Budgets.AddBudgetItemAsync(budgetItem);
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
                        await _unitOfWork.Budgets.AddBudgetItemAsync(budgetItem);
                    }
                }
            }
        }
        /// <summary>
        /// Updates the total budget amount
        /// </summary>
        private async Task UpdateBudgetTotalAsync(int itineraryId, decimal totalCost, Budget? budget)
        {
            if (totalCost <= 0) return;

            if (budget != null)
            {
                budget.TotalBudget = totalCost;
                _unitOfWork.Budgets.Update(budget);
            }
            else
            {
                var newBudget = new Budget
                {
                    ItineraryId = itineraryId,
                    TotalBudget = totalCost
                };
                await _unitOfWork.Budgets.AddAsync(newBudget);
            }
        }
    }

}

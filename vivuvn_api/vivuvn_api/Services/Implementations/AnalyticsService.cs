using Microsoft.EntityFrameworkCore;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.Helpers;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Services.Implementations
{
	public class AnalyticsService(IUnitOfWork _unitOfWork) : IAnalyticsService
	{
		public async Task<DashboardOverviewDto> GetDashboardOverviewAsync(GetAnalyticsRequestDto requestDto)
		{
			// Count total travelers (users with Traveler role)
			var totalTravelers = (await _unitOfWork.Users.GetAllAsync(u => u.UserRoles.Any(r => r.Role.Name == Constants.Role_Traveler)
				, includeProperties: "UserRoles,UserRoles.Role"))
				.Count();

			// Count total locations (not deleted)
			var totalLocations = (await _unitOfWork.Locations.GetAllAsync(l => !l.DeleteFlag)).Count();

			// Count total provinces (not deleted)
			var totalProvinces = (await _unitOfWork.Provinces.GetAllAsync(l => !l.DeleteFlag)).Count();

			// Build query for itineraries based on date filters
			var itinerariesQuery = _unitOfWork.Itineraries.GetQueryable().Where(i => !i.DeleteFlag);

			if (requestDto.StartDate.HasValue)
			{
				itinerariesQuery = itinerariesQuery.Where(i => i.StartDate >= requestDto.StartDate.Value);
			}

			if (requestDto.EndDate.HasValue)
			{
				itinerariesQuery = itinerariesQuery.Where(i => i.StartDate <= requestDto.EndDate.Value);
			}

			var totalItineraries = await itinerariesQuery.CountAsync();

			return new DashboardOverviewDto
			{
				TotalTravelers = totalTravelers,
				TotalLocations = totalLocations,
				TotalProvinces = totalProvinces,
				TotalItineraries = totalItineraries
			};
		}

		public async Task<IEnumerable<TopProvinceDto>> GetTopProvincesAsync(GetAnalyticsRequestDto requestDto)
		{
			var limit = requestDto.Limit ?? 5;

			// Build query for itineraries based on date filters
			var itinerariesQuery = _unitOfWork.Itineraries.GetQueryable().Where(i => !i.DeleteFlag);

			if (requestDto.StartDate.HasValue)
			{
				itinerariesQuery = itinerariesQuery.Where(i => i.StartDate >= requestDto.StartDate.Value);
			}

			if (requestDto.EndDate.HasValue)
			{
				itinerariesQuery = itinerariesQuery.Where(i => i.StartDate <= requestDto.EndDate.Value);
			}

			// Query to get top provinces by counting how many times locations from each province
			// appear in itinerary items
			var topProvinces = await (
				from item in _unitOfWork.ItineraryItems.GetQueryable()
				join day in _unitOfWork.ItineraryDays.GetQueryable() on item.ItineraryDayId equals day.Id
				join itinerary in itinerariesQuery on day.ItineraryId equals itinerary.Id
				join location in _unitOfWork.Locations.GetQueryable() on item.LocationId equals location.Id
				join province in _unitOfWork.Provinces.GetQueryable() on location.ProvinceId equals province.Id
				where item.LocationId.HasValue && !location.DeleteFlag && !province.DeleteFlag
				group new { itinerary.Id, province } by new { province.Id, province.Name } into g
				select new TopProvinceDto
				{
					ProvinceId = g.Key.Id,
					ProvinceName = g.Key.Name,
					VisitCount = g.Select(x => x.Id).Distinct().Count() // Count distinct itineraries
				}
			)
			.OrderByDescending(p => p.VisitCount)
			.Take(limit)
			.ToListAsync();

			return topProvinces;
		}

		public async Task<IEnumerable<TopLocationDto>> GetTopLocationsAsync(GetAnalyticsRequestDto requestDto)
		{
			var limit = requestDto.Limit ?? 10;

			// Build query for itineraries based on date filters
			var itinerariesQuery = _unitOfWork.Itineraries.GetQueryable().Where(i => !i.DeleteFlag);

			if (requestDto.StartDate.HasValue)
			{
				itinerariesQuery = itinerariesQuery.Where(i => i.StartDate >= requestDto.StartDate.Value);
			}

			if (requestDto.EndDate.HasValue)
			{
				itinerariesQuery = itinerariesQuery.Where(i => i.StartDate <= requestDto.EndDate.Value);
			}

			// Query to get top locations by counting how many times each location
			// appears in itinerary items
			var topLocations = await (
				from item in _unitOfWork.ItineraryItems.GetQueryable()
				join day in _unitOfWork.ItineraryDays.GetQueryable() on item.ItineraryDayId equals day.Id
				join itinerary in itinerariesQuery on day.ItineraryId equals itinerary.Id
				join location in _unitOfWork.Locations.GetQueryable() on item.LocationId equals location.Id
				join province in _unitOfWork.Provinces.GetQueryable() on location.ProvinceId equals province.Id
				where item.LocationId.HasValue && !location.DeleteFlag && !province.DeleteFlag
				group new { location, province } by new { location.Id, LocationName = location.Name, ProvinceName = province.Name } into g
				select new TopLocationDto
				{
					LocationId = g.Key.Id,
					LocationName = g.Key.LocationName,
					ProvinceName = g.Key.ProvinceName,
					VisitCount = g.Count()
				}
			)
			.OrderByDescending(l => l.VisitCount)
			.Take(limit)
			.ToListAsync();

			return topLocations;
		}

		public async Task<IEnumerable<ItineraryTrendDto>> GetItineraryTrendsAsync(GetAnalyticsRequestDto requestDto)
		{
			var groupBy = requestDto.GroupBy?.ToLower() ?? "day";

			// Build query for itineraries based on date filters
			var itinerariesQuery = _unitOfWork.Itineraries.GetQueryable().Where(i => !i.DeleteFlag);

			if (requestDto.StartDate.HasValue)
			{
				itinerariesQuery = itinerariesQuery.Where(i => i.StartDate >= requestDto.StartDate.Value);
			}

			if (requestDto.EndDate.HasValue)
			{
				itinerariesQuery = itinerariesQuery.Where(i => i.StartDate <= requestDto.EndDate.Value);
			}

			// Default to last 30 days if no date range specified
			if (!requestDto.StartDate.HasValue && !requestDto.EndDate.HasValue)
			{
				var defaultStartDate = DateTime.Today.AddDays(-30);
				itinerariesQuery = itinerariesQuery.Where(i => i.StartDate >= defaultStartDate);
			}

			switch (groupBy)
			{
				case "week":
					var weeklyTrends = await itinerariesQuery
						.GroupBy(i => new
						{
							Year = i.StartDate.Year,
							Week = EF.Functions.DateDiffWeek(new DateTime(i.StartDate.Year, 1, 1), i.StartDate)
						})
						.Select(g => new
						{
							g.Key.Year,
							g.Key.Week,
							Count = g.Count()
						})
						.OrderBy(t => t.Year).ThenBy(t => t.Week)
						.ToListAsync();
					
					return weeklyTrends.Select(t => new ItineraryTrendDto
					{
						Date = $"{t.Year}-W{t.Week}",
						Count = t.Count
					}).ToList();

				case "month":
					var monthlyTrends = await itinerariesQuery
						.GroupBy(i => new { i.StartDate.Year, i.StartDate.Month })
						.Select(g => new
						{
							g.Key.Year,
							g.Key.Month,
							Count = g.Count()
						})
						.OrderBy(t => t.Year).ThenBy(t => t.Month)
						.ToListAsync();
					
					return monthlyTrends.Select(t => new ItineraryTrendDto
					{
						Date = $"{t.Year}-{t.Month:D2}",
						Count = t.Count
					}).ToList();

				case "day":
				default:
					var dailyTrends = await itinerariesQuery
						.GroupBy(i => i.StartDate.Date)
						.Select(g => new
						{
							Date = g.Key,
							Count = g.Count()
						})
						.OrderBy(t => t.Date)
						.ToListAsync();
					
					return dailyTrends.Select(t => new ItineraryTrendDto
					{
						Date = t.Date.ToString("yyyy-MM-dd"),
						Count = t.Count
					}).ToList();
			}
		}
	}
}

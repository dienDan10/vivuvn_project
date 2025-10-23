using AutoMapper;
using vivuvn_api.DTOs.Request;
using vivuvn_api.DTOs.Response;
using vivuvn_api.DTOs.ValueObjects;
using vivuvn_api.Models;

namespace vivuvn_api.Mappings
{
    public class AutoMapperProfiles : Profile
    {
        public AutoMapperProfiles()
        {
            // CreateMap<Source, Destination>();

            // Mapping For User
            CreateMap<User, UserDto>()
                .ForMember(dest => dest.IsLocked, opt => opt.MapFrom(src => src.LockoutEnd.HasValue && src.LockoutEnd.Value > DateTime.UtcNow))
                .ForMember(dest => dest.Roles, opt => opt.MapFrom(src => src.UserRoles.Select(ur => ur.Role.Name).ToList()));

            // Mapping For Itinerary
            CreateMap<Itinerary, ItineraryDto>()
                .ForMember(dest => dest.StartProvinceName, opt => opt.MapFrom(src => src.StartProvince.Name))
                .ForMember(dest => dest.DestinationProvinceName, opt => opt.MapFrom(src => src.DestinationProvince.Name))
                .ForMember(dest => dest.ImageUrl, opt => opt.MapFrom(src => src.DestinationProvince.ImageUrl))
                .ForMember(dest => dest.FavoritePlaces, opt => opt.MapFrom(src => src.FavoritePlaces.Select(fp => fp.Location).ToList()));

            // Mapping For Itinerary Day
            CreateMap<ItineraryDay, ItineraryDayDto>();


            // Mapping For Itinerary Item
            CreateMap<ItineraryItem, ItineraryItemDto>();

            // Mapping For Location
            CreateMap<Location, LocationDto>()
                .ForMember(dest => dest.ProvinceName, opt => opt.MapFrom(src => src.Province.Name))
                .ForMember(dest => dest.Photos, opt => opt.MapFrom(src => src.LocationPhotos.Select(p => p.PhotoUrl).ToList()));

            // Mapping For Search Location
            CreateMap<Location, SearchLocationDto>();

            // Mapping For Restaurant (Google Places API to RestaurantDto)
            CreateMap<Place, RestaurantDto>()
                .ForMember(dest => dest.GooglePlaceId, opt => opt.MapFrom(src => src.Id))
                .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.DisplayName != null ? src.DisplayName.Text : string.Empty))
                .ForMember(dest => dest.Address, opt => opt.MapFrom(src => src.FormattedAddress ?? string.Empty))
                .ForMember(dest => dest.Latitude, opt => opt.MapFrom(src => src.Location != null ? src.Location.Latitude : (double?)null))
                .ForMember(dest => dest.Longitude, opt => opt.MapFrom(src => src.Location != null ? src.Location.Longitude : (double?)null))
                .ForMember(dest => dest.Photos, opt => opt.MapFrom(src => src.Photos != null ? src.Photos.Select(p => p.Name).ToList() : null));

            // Mapping For Budget
            CreateMap<Budget, BudgetDto>();

            // Mapping for Budget Item
            CreateMap<BudgetItem, BudgetItemDto>()
                .ForMember(dest => dest.BudgetType, opt => opt.MapFrom(src => src.BudgetType != null ? src.BudgetType.Name : null));

            // Mapping for Budget Type
            CreateMap<BudgetType, BudgetTypeDto>();

            // Mapping for Province
            CreateMap<Province, ProvinceDto>();
            CreateMap<CreateProvinceRequestDto, Province>()
                .ForMember(dest => dest.ImageUrl, opt => opt.Ignore())
                .ForMember(dest => dest.DeleteFlag, opt => opt.MapFrom(src => false));
            CreateMap<UpdateProvinceRequestDto, Province>()
                .ForMember(dest => dest.ImageUrl, opt => opt.Ignore());

            // Mapping for Favorite Place
            CreateMap<FavoritePlace, FavoritePlaceDto>();

            // Mapping for AI Generated Itinerary to Database Models
            // Map TravelItinerary to Itinerary (updates existing itinerary)
            CreateMap<TravelItinerary, Itinerary>()
                .ForMember(dest => dest.Days, opt => opt.MapFrom(src => src.Days))
                .ForMember(dest => dest.Id, opt => opt.Ignore())
                .ForMember(dest => dest.UserId, opt => opt.Ignore())
                .ForMember(dest => dest.User, opt => opt.Ignore())
                .ForMember(dest => dest.Name, opt => opt.Ignore())
                .ForMember(dest => dest.StartProvinceId, opt => opt.Ignore())
                .ForMember(dest => dest.StartProvince, opt => opt.Ignore())
                .ForMember(dest => dest.DestinationProvinceId, opt => opt.Ignore())
                .ForMember(dest => dest.DestinationProvince, opt => opt.Ignore())
                .ForMember(dest => dest.StartDate, opt => opt.Ignore())
                .ForMember(dest => dest.EndDate, opt => opt.Ignore())
                .ForMember(dest => dest.DaysCount, opt => opt.Ignore())
                .ForMember(dest => dest.GroupSize, opt => opt.Ignore())
                .ForMember(dest => dest.DeleteFlag, opt => opt.Ignore())
                .ForMember(dest => dest.TransportationVehicle, opt => opt.MapFrom(src => src.TransportationSuggestions[0].Mode))
                .ForMember(dest => dest.Budget, opt => opt.Ignore())
                .ForMember(dest => dest.FavoritePlaces, opt => opt.Ignore());

            // Map AIDayItineraryDto to ItineraryDay
            CreateMap<AIDayItineraryDto, ItineraryDay>()
                .ForMember(dest => dest.Id, opt => opt.Ignore())
                .ForMember(dest => dest.ItineraryId, opt => opt.Ignore())
                .ForMember(dest => dest.DayNumber, opt => opt.MapFrom(src => src.Day))
                .ForMember(dest => dest.Date, opt => opt.MapFrom(src => src.Date))
                .ForMember(dest => dest.Items, opt => opt.MapFrom(src => src.Activities));

            // Map AIActivityDto to ItineraryItem
            CreateMap<AIActivityDto, ItineraryItem>()
                .ForMember(dest => dest.ItineraryItemId, opt => opt.Ignore())
                .ForMember(dest => dest.ItineraryDayId, opt => opt.Ignore())
                .ForMember(dest => dest.ItineraryDay, opt => opt.Ignore())
                .ForMember(dest => dest.LocationId, opt => opt.Ignore()) // Will be set by service layer
                .ForMember(dest => dest.Location, opt => opt.Ignore())
                .ForMember(dest => dest.OrderIndex, opt => opt.Ignore()) // Will be set by service layer
                .ForMember(dest => dest.Note, opt => opt.MapFrom(src => $"{src.Name} - {src.Category}"))
                .ForMember(dest => dest.EstimateDuration, opt => opt.MapFrom(src => src.DurationHours * 60)) // Convert hours to minutes
                .ForMember(dest => dest.StartTime, opt => opt.MapFrom(src => src.Time))
                .ForMember(dest => dest.EndTime, opt => opt.MapFrom(src => src.Time.AddHours(src.DurationHours)))
                .ForMember(dest => dest.TransportationVehicle, opt => opt.Ignore()) // Will be set by service layer
                .ForMember(dest => dest.TransportationDuration, opt => opt.Ignore())
                .ForMember(dest => dest.TransportationDistance, opt => opt.Ignore());

        }
    }
}

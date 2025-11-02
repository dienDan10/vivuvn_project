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
                .ForMember(dest => dest.IsOwner, opt => opt.MapFrom(src => src.User.Id == src.UserId))
                .ForMember(dest => dest.Owner, opt => opt.MapFrom(src => src.User))
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
                .ForMember(dest => dest.Photos, opt => opt.MapFrom(src => src.Photos.Select(p => p.PhotoUrl).ToList()));

            // Mapping For Search Location
            CreateMap<Location, SearchLocationDto>();

            // Mapping For Search Place from Google
            CreateMap<SimplifiedPlace, SearchPlaceDto>()
                .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.DisplayName != null ? src.DisplayName.Text : string.Empty))
                .ForMember(dest => dest.FormattedAddress, opt => opt.MapFrom(src => src.FormattedAddress ?? string.Empty));

            // Mapping For Restaurant (Restaurant from DB to RestaurantDto)
            CreateMap<Restaurant, RestaurantDto>()
                .ForMember(dest => dest.Photos, opt => opt.MapFrom(src => src.Photos.Select(p => p.PhotoUrl).ToList()));

            // Mapping For RestaurantDto (from dto to restaurant entity)
            CreateMap<RestaurantDto, Restaurant>()
                .ForMember(dest => dest.Photos, opt => opt.MapFrom(src => src.Photos.Select(p => new Models.Photo { PhotoUrl = p }).ToList()));

            // Mapping For Restaurant (Google Places API to RestaurantDto)
            CreateMap<Place, RestaurantDto>()
                .ForMember(dest => dest.Id, opt => opt.Ignore())
                .ForMember(dest => dest.GooglePlaceId, opt => opt.MapFrom(src => src.Id))
                .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.DisplayName != null ? src.DisplayName.Text : string.Empty))
                .ForMember(dest => dest.Address, opt => opt.MapFrom(src => src.FormattedAddress ?? string.Empty))
                .ForMember(dest => dest.Latitude, opt => opt.MapFrom(src => src.Location != null ? src.Location.Latitude : (double?)null))
                .ForMember(dest => dest.Longitude, opt => opt.MapFrom(src => src.Location != null ? src.Location.Longitude : (double?)null))
                .ForMember(dest => dest.Photos, opt => opt.MapFrom(src => src.Photos != null ? src.Photos.Select(p => p.Name).ToList() : null));


            // Mapping For Hotel (Hotel from DB to HotelDto)
            CreateMap<Hotel, HotelDto>()
                .ForMember(dest => dest.Photos, opt => opt.MapFrom(src => src.Photos.Select(p => p.PhotoUrl).ToList()));

            // Mapping For HotelDto (from dto to hotel entity)
            CreateMap<HotelDto, Hotel>()
                .ForMember(dest => dest.Photos, opt => opt.MapFrom(src => src.Photos.Select(p => new Models.Photo { PhotoUrl = p }).ToList()));

            // Mapping For Hotel (Google Places API to HotelDto)
            CreateMap<Place, HotelDto>()
                .ForMember(dest => dest.Id, opt => opt.Ignore())
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

            // Mapping for Itinerary Hotel
            CreateMap<ItineraryHotel, ItineraryHotelDto>()
                .ForMember(dest => dest.Cost, opt => opt.MapFrom(src => src.BudgetItem != null ? src.BudgetItem.Cost : 0));

            // Mapping for Itinerary Restaurant
            CreateMap<ItineraryRestaurant, ItineraryRestaurantDto>()
                .ForMember(dest => dest.Cost, opt => opt.MapFrom(src => src.BudgetItem != null ? src.BudgetItem.Cost : 0));

            // Mapping for AI Generated Itinerary to Database Models
            CreateMap<AIActivityDto, ItineraryItem>()
                .ForMember(dest => dest.ItineraryItemId, opt => opt.Ignore())
                .ForMember(dest => dest.ItineraryDayId, opt => opt.Ignore())
                .ForMember(dest => dest.ItineraryDay, opt => opt.Ignore())
                .ForMember(dest => dest.LocationId, opt => opt.Ignore()) // Will be set by service layer
                .ForMember(dest => dest.Location, opt => opt.Ignore())
                .ForMember(dest => dest.OrderIndex, opt => opt.Ignore()) // Will be set by service layer
                .ForMember(dest => dest.EstimateDuration, opt => opt.MapFrom(src => src.DurationHours * 60)) // Convert hours to minutes
                .ForMember(dest => dest.StartTime, opt => opt.MapFrom(src => src.Time))
                .ForMember(dest => dest.EndTime, opt => opt.MapFrom(src => src.Time.AddHours(src.DurationHours)))
                .ForMember(dest => dest.Note, opt => opt.MapFrom(src => src.Notes))
                .ForMember(dest => dest.TransportationVehicle, opt => opt.Ignore()) // Will be set by service layer
                .ForMember(dest => dest.TransportationDuration, opt => opt.Ignore())
                .ForMember(dest => dest.TransportationDistance, opt => opt.Ignore());

            // Mapping for Itinerary Member
            CreateMap<ItineraryMember, ItineraryMemberDto>()
                .ForMember(dest => dest.MemberId, opt => opt.MapFrom(src => src.Id))
                .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.User.Email))
                .ForMember(dest => dest.Username, opt => opt.MapFrom(src => src.User.Username))
                .ForMember(dest => dest.Photo, opt => opt.MapFrom(src => src.User.UserPhoto))
                .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.User.PhoneNumber))
                .ForMember(dest => dest.JoinedAt, opt => opt.MapFrom(src => src.JoinedAt))
                .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.Role));

            // Mapping for Itinerary Message
            CreateMap<ItineraryMessage, ItineraryMessageDto>()
                .ForMember(dest => dest.MemberId, opt => opt.MapFrom(src => src.ItineraryMember.Id))
                .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.ItineraryMember.User.Email))
                .ForMember(dest => dest.Username, opt => opt.MapFrom(src => src.ItineraryMember.User.Username))
                .ForMember(dest => dest.Photo, opt => opt.MapFrom(src => src.ItineraryMember.User.UserPhoto));

        }
    }
}

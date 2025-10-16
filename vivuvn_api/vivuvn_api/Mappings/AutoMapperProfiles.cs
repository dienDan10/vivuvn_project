using AutoMapper;
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

            // Mapping For Budget
            CreateMap<Budget, BudgetDto>();

            // Mapping for Budget Item
            CreateMap<BudgetItem, BudgetItemDto>()
                .ForMember(dest => dest.BudgetType, opt => opt.MapFrom(src => src.BudgetType != null ? src.BudgetType.Name : null));

            // Mapping for Province
            CreateMap<Province, ProvinceDto>();

            // Mapping for Favorite Place
            CreateMap<FavoritePlace, FavoritePlaceDto>();

        }
    }
}

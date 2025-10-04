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

        }
    }
}

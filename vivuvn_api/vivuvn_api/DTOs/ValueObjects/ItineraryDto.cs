namespace vivuvn_api.DTOs.ValueObjects
{
    public class ItineraryDto
    {
        public int Id { get; set; }
        public UserDto Owner { get; set; } = null!;
        public bool IsOwner { get; set; } = false;
        public bool IsMember { get; set; } = false;
        public string Name { get; set; } = string.Empty;
        public int StartProvinceId { get; set; }
        public string StartProvinceName { get; set; } = string.Empty;
        public string? ImageUrl { get; set; }
        public int DestinationProvinceId { get; set; }
        public string DestinationProvinceName { get; set; } = string.Empty;
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int DaysCount { get; set; }
        public int GroupSize { get; set; }
        public string? TransportationVehicle { get; set; }
        public bool IsPublic { get; set; } = false;
        public string? InviteCode { get; set; }
        public DateTime? InviteCodeGeneratedAt { get; set; }

        public List<ItineraryDayDto> Days { get; set; } = new List<ItineraryDayDto>();
        public BudgetDto Budget { get; set; }
        public List<LocationDto> FavoritePlaces { get; set; } = new List<LocationDto>();
        public List<ItineraryHotelDto> Hotels { get; set; } = new List<ItineraryHotelDto>();
        public List<ItineraryRestaurantDto> Restaurants { get; set; } = new List<ItineraryRestaurantDto>();

    }
}

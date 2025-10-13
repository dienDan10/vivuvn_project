using vivuvn_api.Models;

namespace vivuvn_api.DTOs.ValueObjects
{
    public class ItineraryDto
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public User User { get; set; } = null!;
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

        public List<ItineraryDayDto> Days { get; set; } = new List<ItineraryDayDto>();
        public BudgetDto Budget { get; set; }

    }
}

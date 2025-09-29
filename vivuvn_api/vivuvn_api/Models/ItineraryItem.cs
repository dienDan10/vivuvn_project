using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class ItineraryItem
    {
        [Key]
        public int ItineraryItemId { get; set; }

        [Required]
        public int ItineraryDayId { get; set; }
        public ItineraryDay ItineraryDay { get; set; } = null!;

        public int? LocationId { get; set; }
        public Location? Location { get; set; }

        public int OrderIndex { get; set; }
        public string? Note { get; set; }
        public double? EstimateDuration { get; set; }

        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }

        public string? TransportationVehicle { get; set; }
        public double? TransportationDuration { get; set; }
        public double? TransportationDistance { get; set; }
    }
}

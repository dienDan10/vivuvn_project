using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class ExternalService
    {
        [Key]
        public int Id { get; set; }

        public int ItineraryDayId { get; set; }
        public ItineraryDay ItineraryDay { get; set; } = null!;

        public int ServiceTypeId { get; set; }
        public ServiceType ServiceType { get; set; } = null!;

        public string? GoogleApiUri { get; set; }
        public string? GooglePlaceId { get; set; }
        public string? Notes { get; set; }
        public double? Rating { get; set; }
    }
}

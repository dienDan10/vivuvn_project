namespace vivuvn_api.DTOs.ValueObjects
{
    public class ItineraryItemDto
    {
        public int ItineraryItemId { get; set; }
        public LocationDto? Location { get; set; } = null;

        public int OrderIndex { get; set; }
        public string? Note { get; set; }
        public double? EstimateDuration { get; set; }

        public TimeOnly? StartTime { get; set; }
        public TimeOnly? EndTime { get; set; }

        public string? TransportationVehicle { get; set; }
        public double? TransportationDuration { get; set; }
        public double? TransportationDistance { get; set; }
    }
}

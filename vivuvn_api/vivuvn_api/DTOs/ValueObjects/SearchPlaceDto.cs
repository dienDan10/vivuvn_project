namespace vivuvn_api.DTOs.ValueObjects
{
    public class SearchPlaceDto
    {
        public string GooglePlaceId { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string? FormattedAddress { get; set; }
    }
}

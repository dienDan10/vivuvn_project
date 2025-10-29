namespace vivuvn_api.DTOs.ValueObjects
{
    public class FavoritePlaceDto
    {
        public int Id { get; set; }
        public LocationDto? Location { get; set; } = null;
    }
}

namespace vivuvn_api.Models
{
    public class LocationPhoto
    {
        public int LocationId { get; set; }
        public Location Location { get; set; } = null!;

        public int PhotoId { get; set; }
        public Photo Photo { get; set; } = null!;
    }
}

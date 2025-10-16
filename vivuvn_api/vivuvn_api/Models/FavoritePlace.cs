using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class FavoritePlace
    {
        [Key]
        public int Id { get; set; }

        public int ItineraryId { get; set; }

        public int LocationId { get; set; }
        public Location Location { get; set; } = null!;
    }
}

using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class ItineraryDay
    {
        [Key]
        public int Id { get; set; }

        public int ItineraryId { get; set; }
        public Itinerary Itinerary { get; set; } = null!;

        public int DayNumber { get; set; }
        public DateTime Date { get; set; }

        public ICollection<ItineraryItem> Items { get; set; } = new List<ItineraryItem>();
        public ICollection<ExternalService> ExternalServices { get; set; } = new List<ExternalService>();
    }
}

using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class ItineraryHotel
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int ItineraryId { get; set; }
        public Itinerary Itinerary { get; set; } = null!;

        public int? HotelId { get; set; }
        public Hotel? Hotel { get; set; }

        public DateOnly? CheckIn { get; set; }
        public DateOnly? CheckOut { get; set; }

        public string? Notes { get; set; }

        public int? BudgetItemId { get; set; }
        public BudgetItem? BudgetItem { get; set; }
    }
}

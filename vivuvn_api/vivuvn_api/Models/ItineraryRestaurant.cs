using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class ItineraryRestaurant
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int ItineraryId { get; set; }
        public Itinerary Itinerary { get; set; } = null!;

        public int? RestaurantId { get; set; }
        public Restaurant? Restaurant { get; set; }

        public DateOnly? Date { get; set; }
        public TimeOnly? Time { get; set; }

        public string? Notes { get; set; }

        public int? BudgetItemId { get; set; }
        public BudgetItem? BudgetItem { get; set; }
    }
}

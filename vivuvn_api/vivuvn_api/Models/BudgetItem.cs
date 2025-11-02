using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class BudgetItem
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string Name { get; set; }

        [Required]
        public int BudgetId { get; set; }
        public Budget Budget { get; set; } = null!;

        public decimal Cost { get; set; }

        [Required]
        public DateTime Date { get; set; }

        public int BudgetTypeId { get; set; }
        public BudgetType BudgetType { get; set; } = null!;

        // Navigation
        public ItineraryHotel? ItineraryHotel { get; set; }
        public ItineraryRestaurant? ItineraryRestaurant { get; set; }

    }
}

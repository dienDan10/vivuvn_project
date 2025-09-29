using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class Budget
    {
        [Key]
        public int BudgetId { get; set; }

        [Required]
        public int ItineraryId { get; set; }
        public Itinerary Itinerary { get; set; } = null!;

        public decimal TotalBudget { get; set; }

        // Navigation
        public ICollection<BudgetItem> Items { get; set; } = new List<BudgetItem>();
    }
}

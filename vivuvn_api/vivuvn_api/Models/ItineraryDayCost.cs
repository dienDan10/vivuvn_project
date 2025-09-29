using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class ItineraryDayCost
    {
        [Key]
        public int Id { get; set; }

        public string? Description { get; set; }

        public int BudgetItemId { get; set; }
        public BudgetItem BudgetItem { get; set; } = null!;

        public int ItineraryDayId { get; set; }
        public ItineraryDay ItineraryDay { get; set; } = null!;
    }
}

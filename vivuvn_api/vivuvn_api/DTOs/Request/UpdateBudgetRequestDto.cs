using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class UpdateBudgetRequestDto
    {
        [Required]
        [Range(100, int.MaxValue, ErrorMessage = "The estimated cost is too low")]
        public decimal? EstimatedBudget { get; set; }
    }
}

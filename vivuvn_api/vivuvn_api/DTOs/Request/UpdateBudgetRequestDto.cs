using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class UpdateBudgetRequestDto
    {
        [Required]
        public decimal? EstimatedBudget { get; set; }
    }
}

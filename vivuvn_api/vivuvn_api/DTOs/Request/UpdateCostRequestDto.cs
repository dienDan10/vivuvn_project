using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class UpdateCostRequestDto
    {
        [Required]
        [Range(0, double.MaxValue, ErrorMessage = "Cost must be a non-negative value.")]
        public decimal Cost { get; set; }
    }
}

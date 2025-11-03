using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class CreateBudgetItemRequestDto
    {
        public string? Name { get; set; }
        [Required]
        public decimal Cost { get; set; }
        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Invalid Budget type id")]
        public int BudgetTypeId { get; set; }
        [Required]
        public DateTime Date { get; set; }
        public int? MemberId { get; set; }
    }
}

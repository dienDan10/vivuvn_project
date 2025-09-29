using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class BudgetType
    {
        [Key]
        public int BudgetTypeId { get; set; }

        [Required]
        public string Name { get; set; } = string.Empty;
    }
}

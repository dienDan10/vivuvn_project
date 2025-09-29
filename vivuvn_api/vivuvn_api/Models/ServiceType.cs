using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class ServiceType
    {
        [Key]
        public int ServiceTypeId { get; set; }

        [Required]
        public string Name { get; set; } = string.Empty;
    }
}

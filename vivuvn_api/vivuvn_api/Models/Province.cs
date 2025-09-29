using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.Models
{
    public class Province
    {
        [Key]
        public int Id { get; set; }

        public string Name { get; set; } = string.Empty;
        public string ProvinceCode { get; set; } = string.Empty;
        public bool DeleteFlag { get; set; }
    }
}

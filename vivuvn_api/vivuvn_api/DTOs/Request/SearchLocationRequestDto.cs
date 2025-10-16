using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class SearchLocationRequestDto
    {
        public string? Name { get; set; }

        [Range(1, int.MaxValue, ErrorMessage = "Limit must be a positive integer.")]
        public int Limit { get; set; } = 10;
    }
}

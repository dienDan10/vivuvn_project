using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class GetAllUsersRequestDto
    {
        public string? Username { get; set; }
        public string? Email { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Role { get; set; }  // Filter by role name (Admin, Operator, Traveler)

        // Sorting
        public string? SortBy { get; set; }
        public bool IsDescending { get; set; } = false;

        // Pagination
        [Range(1, int.MaxValue, ErrorMessage = "Page number must be greater than 0.")]
        public int PageNumber { get; set; } = 1;

        [Range(1, 100, ErrorMessage = "Page size must be between 1 and 100.")]
        public int PageSize { get; set; } = 10;
    }
}

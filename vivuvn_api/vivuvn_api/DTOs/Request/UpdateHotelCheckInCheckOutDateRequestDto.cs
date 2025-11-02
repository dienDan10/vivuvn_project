using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class UpdateHotelCheckInCheckOutDateRequestDto
    {
        [Required]
        public DateOnly CheckIn { get; set; }

        [Required]
        public DateOnly CheckOut { get; set; }
    }
}

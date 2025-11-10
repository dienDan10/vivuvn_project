using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class ChangePhoneNumberRequest
    {
        [Required]
        public string PhoneNumber { get; set; } = null!;
    }
}

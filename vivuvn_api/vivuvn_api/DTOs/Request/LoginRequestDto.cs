﻿using System.ComponentModel.DataAnnotations;

namespace vivuvn_api.DTOs.Request
{
    public class LoginRequestDto
    {
        [Required]
        public string Email { get; set; } = string.Empty;
        [Required]
        public string Password { get; set; } = string.Empty;
    }
}

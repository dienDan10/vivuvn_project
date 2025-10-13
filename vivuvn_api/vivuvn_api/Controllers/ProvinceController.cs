using Microsoft.AspNetCore.Mvc;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/provinces")]
    [ApiController]
    public class ProvinceController(IProvinceService _provinceService) : ControllerBase
    {
        [HttpGet("search")]
        public async Task<IActionResult> SearchProvinces([FromQuery] SearchProvinceRequestDto requestDto)
        {

            // Dummy data for demonstration purposes
            var provinces = await _provinceService.SearchProvinceAsync(requestDto.Name, requestDto.Limit);
            return Ok(provinces);
        }

    }
}

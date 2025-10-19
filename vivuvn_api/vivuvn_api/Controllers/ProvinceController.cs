using Microsoft.AspNetCore.Authorization;
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

        [HttpGet]
        [Authorize(Roles = "Admin")]
		public async Task<IActionResult> GetAllProvinces()
        {
            var provinces = await _provinceService.GetAllProvincesAsync();
            return Ok(provinces);
		}

		[HttpPut("{id:int}/restore")]
		[Authorize(Roles = "Admin")]
		public async Task<IActionResult> RestoreProvice(int id)
		{
			var provinces = await _provinceService.RestoreProvince(id);
			return Ok(provinces);
		}

		[HttpDelete("{id:int}")]
		[Authorize(Roles = "Admin")]
		public async Task<IActionResult> DeleteProvice(int id)
		{
			await _provinceService.DeleteProvince(id);
			return Ok();
		}
	}
}

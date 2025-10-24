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

            var provinces = await _provinceService.SearchProvinceAsync(requestDto.Name, requestDto.Limit);
            return Ok(provinces);
        }

        [HttpGet]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> GetAllProvinces([FromQuery] GetAllProvincesRequestDto requestDto)
        {
            var provinces = await _provinceService.GetAllProvincesAsync(requestDto);
            return Ok(provinces);
        }

        [HttpPut("{id:int}/restore")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> RestoreProvice(int id)
        {
            var provinces = await _provinceService.RestoreProvinceAsync(id);
            return Ok(provinces);
        }

        [HttpDelete("{id:int}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteProvice(int id)
        {
            await _provinceService.DeleteProvinceAsync(id);
            return Ok();
        }

        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetProvinceById(int id)
        {
            var province = await _provinceService.GetProvinceByIdAsync(id);
            return Ok(province);
        }

        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> CreateProvince([FromForm] CreateProvinceRequestDto requestDto)
        {
            var province = await _provinceService.CreateProvinceAsync(requestDto);
            return CreatedAtAction(nameof(GetProvinceById), new { id = province.Id }, province);
        }

        [HttpPut("{id:int}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> UpdateProvince(int id, [FromForm] UpdateProvinceRequestDto requestDto)
        {
            var province = await _provinceService.UpdateProvinceAsync(id, requestDto);
            return Ok(province);
        }

    }
}

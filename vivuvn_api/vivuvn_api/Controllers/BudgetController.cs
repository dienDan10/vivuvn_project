using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries/{itineraryId}/budget")]
    [ApiController]
    public class BudgetController(IBudgetService _budgetService) : ControllerBase
    {

        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetBudget(int itineraryId)
        {
            var budget = await _budgetService.GetBudgetByItineraryIdAsync(itineraryId);
            return Ok(budget);
        }

        [HttpGet("items")]
        [Authorize]
        public async Task<IActionResult> GetBudgetItems(int itineraryId)
        {
            var budgetItems = await _budgetService.GetBudgetItemsAsync(itineraryId);
            return Ok(budgetItems);
        }

        [HttpGet("budget-types")]
        [Authorize]
        public async Task<IActionResult> GetBudgetTypes()
        {
            var budgetTypes = await _budgetService.GetBudgetTypesAsync();
            return Ok(budgetTypes);
        }

        [HttpPost("items")]
        [Authorize]
        public async Task<IActionResult> CreateBudgetItem(int itineraryId, CreateBudgetItemRequestDto request)
        {
            var budgetItem = await _budgetService.AddBudgetItemAsync(itineraryId, request);
            return Ok(budgetItem);
        }

        [HttpPut]
        [Authorize]
        public async Task<IActionResult> UpdateBudget(int itineraryId, [FromBody] UpdateBudgetRequestDto request)
        {
            var budget = await _budgetService.UpdateBudgetAsync(itineraryId, request);
            return Ok(budget);
        }


        [HttpPut("items/{itemId}")]
        [Authorize]
        public async Task<IActionResult> UpdateBudgetItem(int itineraryId, int itemId, UpdateBudgetItemRequestDto request)
        {
            var budgetItem = await _budgetService.UpdateBudgetItemAsync(itemId, request);
            return Ok(budgetItem);
        }

        [HttpDelete("items/{itemId}")]
        [Authorize]
        public async Task<IActionResult> DeleteBudgetItem(int itineraryId, int itemId)
        {
            var budgetItem = await _budgetService.DeleteBudgetItemAsync(itemId);
            return Ok(budgetItem);
        }

    }
}

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries/{itineraryId}/budget/items")]
    [ApiController]
    public class BudgetController(IBudgetService _budgetService) : ControllerBase
    {
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetBudgetItems(int itineraryId)
        {
            var budgetItems = await _budgetService.GetBudgetItemsAsync(itineraryId);
            return Ok(budgetItems);
        }

        [HttpPost]
        [Authorize]
        public async Task<IActionResult> CreateBudgetItem(int itineraryId, CreateBudgetItemRequestDto request)
        {
            var budgetItem = await _budgetService.AddBudgetItemAsync(itineraryId, request);
            return Ok(budgetItem);
        }

        [HttpPut("{itemId}")]
        [Authorize]
        public async Task<IActionResult> UpdateBudgetItem(int itineraryId, int itemId, UpdateBudgetItemRequestDto request)
        {
            var budgetItem = await _budgetService.UpdateBudgetItemAsync(itemId, request);
            return Ok(budgetItem);
        }
    }
}

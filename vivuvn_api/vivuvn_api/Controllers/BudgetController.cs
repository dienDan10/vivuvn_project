using Microsoft.AspNetCore.Mvc;
using vivuvn_api.DTOs.Request;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Controllers
{
    [Route("api/v1/itineraries/{itineraryId}/budget/items")]
    [ApiController]
    public class BudgetController(IBudgetService _budgetService) : ControllerBase
    {
        [HttpPost]
        public async Task<IActionResult> CreateBudgetItem(int itineraryId, CreateBudgetItemRequestDto request)
        {
            var budgetItem = await _budgetService.AddBudgetItemAsync(itineraryId, request);
            return Ok(budgetItem);
        }
    }
}

namespace vivuvn_api.DTOs.ValueObjects
{
    public class BudgetDto
    {
        public int BudgetId { get; set; }
        public decimal TotalBudget { get; set; }
        public ICollection<BudgetItemDto> Items { get; set; } = new List<BudgetItemDto>();
    }
}

namespace vivuvn_api.DTOs.Request
{
    public class UpdateBudgetItemRequestDto
    {
        public string? Name { get; set; }
        public decimal? Cost { get; set; }

        public DateTime? Date { get; set; }

        public int? BudgetTypeId { get; set; }
    }
}

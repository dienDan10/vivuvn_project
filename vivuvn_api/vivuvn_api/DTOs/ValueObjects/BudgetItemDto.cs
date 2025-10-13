namespace vivuvn_api.DTOs.ValueObjects
{
    public class BudgetItemDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public decimal Cost { get; set; }
        public int BudgetTypeId { get; set; }
        public string BudgetType { get; set; }
    }
}

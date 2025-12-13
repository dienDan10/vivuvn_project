namespace vivuvn_api.DTOs.ValueObjects
{
    public class BudgetItemDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public decimal Cost { get; set; }
        public string? Details { get; set; }
        public DateTime Date { get; set; }
        public string? BudgetType { get; set; }
        public string? BillPhotoUrl { get; set; }
        public ItineraryMemberDto? PaidByMember { get; set; }
    }
}

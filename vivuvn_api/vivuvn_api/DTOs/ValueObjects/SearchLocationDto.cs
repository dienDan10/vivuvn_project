namespace vivuvn_api.DTOs.ValueObjects
{
    public class SearchLocationDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? Address { get; set; }
    }
}

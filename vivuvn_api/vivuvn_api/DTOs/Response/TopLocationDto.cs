namespace vivuvn_api.DTOs.Response
{
    public class TopLocationDto
    {
        public int LocationId { get; set; }
        public string LocationName { get; set; } = string.Empty;
        public string ProvinceName { get; set; } = string.Empty;
        public int VisitCount { get; set; }
    }
}

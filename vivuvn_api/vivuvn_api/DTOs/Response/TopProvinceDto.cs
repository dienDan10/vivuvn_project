namespace vivuvn_api.DTOs.Response
{
    public class TopProvinceDto
    {
        public int ProvinceId { get; set; }
        public string ProvinceName { get; set; } = string.Empty;
        public int VisitCount { get; set; }
    }
}

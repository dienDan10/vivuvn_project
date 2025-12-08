namespace vivuvn_api.DTOs.Request
{
    public class GetAllPublicItinerariesRequestDto
    {
        public int? Page { get; set; }
        public int? PageSize { get; set; }
        public int? ProvinceId { get; set; }
        public bool? SortByDate { get; set; }
        public bool? IsDescending { get; set; }
    }
}

namespace vivuvn_api.DTOs.ValueObjects
{
    public class ProvinceDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string ImageUrl { get; set; } = string.Empty;
		public bool DeleteFlag { get; set; }
		public string ProvinceCode { get; set; }
	}
}

using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Request
{
    public class SearchGooglePlaceTextRequestDto
    {
        [JsonPropertyName("includedType")]
        public string IncludedType { get; set; } = string.Empty;

        [JsonPropertyName("textQuery")]
        public string TextQuery { get; set; } = string.Empty;

        [JsonPropertyName("maxResultCount")]
        public int MaxResultCount { get; set; } = 20;
    }
}

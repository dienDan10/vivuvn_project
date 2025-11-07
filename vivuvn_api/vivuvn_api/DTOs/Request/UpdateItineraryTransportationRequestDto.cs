using System.Text.Json.Serialization;

namespace vivuvn_api.DTOs.Request
{
    public class UpdateItineraryTransportationRequestDto
    {
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public TransportationMode Transportation { get; set; }
    }

    public enum TransportationMode
    {
        Airplane,
        Bus,
        Train,
        PrivateCar,
        Motorbike
    }
}

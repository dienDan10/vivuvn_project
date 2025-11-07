namespace vivuvn_api.DTOs.Request
{
    public class UpdateItineraryTransportationRequestDto
    {
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

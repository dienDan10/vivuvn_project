using vivuvn_api.DTOs.Request;
using vivuvn_api.Helpers;

namespace vivuvn_api.Extensions
{
    public static class TransportationModeExtensions
    {
        public static string ToVietnameseString(this TransportationMode mode)
        {
            return mode switch
            {
                TransportationMode.Airplane => Constants.TransportationMode_Airplane,
                TransportationMode.Bus => Constants.TransportationMode_Bus,
                TransportationMode.Train => Constants.TransportationMode_Train,
                TransportationMode.PrivateCar => Constants.TransportationMode_PrivateCar,
                TransportationMode.Motorbike => Constants.TransportationMode_Motorbike,
                _ => throw new ArgumentOutOfRangeException(nameof(mode), mode, null)
            };
        }

        public static TransportationMode ToTransportationMode(this string vietnameseString)
        {
            return vietnameseString switch
            {
                Constants.TransportationMode_Airplane => TransportationMode.Airplane,
                Constants.TransportationMode_Bus => TransportationMode.Bus,
                Constants.TransportationMode_Train => TransportationMode.Train,
                Constants.TransportationMode_PrivateCar => TransportationMode.PrivateCar,
                Constants.TransportationMode_Motorbike => TransportationMode.Motorbike,
                _ => throw new ArgumentException($"Invalid transportation mode: {vietnameseString}", nameof(vietnameseString))
            };
        }
    }
}
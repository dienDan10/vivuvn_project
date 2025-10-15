namespace vivuvn_api.Helpers
{
    public static class Constants
    {
        // User roles
        public const string Role_Admin = "Admin";
        public const string Role_Operator = "Operator";
        public const string Role_Traveler = "Traveler";

        // JWT configuration
        public const int AccessTokenExpirationMinutes = 5;
        public const int RefreshTokenExpirationDays = 30;

        // Token Configuration
        public const int EmailVerificationTokenExpirationMinutes = 5;
        public static readonly string[] ValidImageExtensions = [".jpg", ".jpeg", ".png", ".gif"];

        // Image Configuration
        public const int MaxImageSizeBytes = 5 * 1024 * 1024; // 5 MB

        // Service Types

        // Budget Types

        // Travel Modes
        public const string TravelMode_Driving = "DRIVE";
        public const string TravelMode_Walking = "WALK";
        public const string TravelMode_Bicycling = "BICYCLE";
        public const string TravelMode_Transit = "TRANSIT";
        public const string TravelMode_Two_Wheeler = "TWO_WHEELER";

    }
}

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
        public const int PasswordResetTokenExpirationMinutes = 10;
        public static readonly string[] ValidImageExtensions = [".jpg", ".jpeg", ".png", ".gif"];

        // Image Configuration
        public const int MaxImageSizeBytes = 5 * 1024 * 1024; // 5 MB

        // Service Types

        // Budget Types
        public const string BudgetType_Flights = "Chuyến bay";
        public const string BudgetType_Lodging = "Chỗ ở";
        public const string BudgetType_CarRental = "Thuê xe";
        public const string BudgetType_Transit = "Vận chuyển";
        public const string BudgetType_Food = "Thực phẩm";
        public const string BudgetType_Drinks = "Đồ uống";
        public const string BudgetType_Sightseeing = "Du lịch tham quan";
        public const string BudgetType_Activities = "Hoạt động";
        public const string BudgetType_Shopping = "Mua sắm";
        public const string BudgetType_Gas = "Xăng";
        public const string BudgetType_Groceries = "Tạp hóa";
        public const string BudgetType_Other = "Khác";

        // Transportation Modes (province travel)
        public const string TransportationMode_Airplane = "Máy bay";
        public const string TransportationMode_Bus = "Xe khách";
        public const string TransportationMode_Train = "Tàu hỏa";
        public const string TransportationMode_PrivateCar = "Ô tô cá nhân";
        public const string TransportationMode_Motorbike = "Xe máy";

        // Travel Modes (for Google Maps routing within city)
        public const string TravelMode_Driving = "DRIVE";
        public const string TravelMode_Walking = "WALK";
        public const string TravelMode_Bicycling = "BICYCLE";
        public const string TravelMode_Transit = "TRANSIT";
        public const string TravelMode_Two_Wheeler = "TWO_WHEELER";

        // Additional 
        public const int DefaultPageSize = 10;

        // Itinerary roles
        public const string ItineraryRole_Owner = "Owner";
        public const string ItineraryRole_Member = "Member";

        // Notification types
        public const string NotificationType_MemberJoined = "MemberJoined";
        public const string NotificationType_MemberLeft = "MemberLeft";
        public const string NotificationType_MemberKicked = "MemberKicked";
        public const string NotificationType_ItineraryUpdated = "ItineraryUpdated";
        public const string NotificationType_ImportantChange = "ImportantChange";
        public const string NotificationType_ExpenseAssigned = "ExpenseAssigned";

        // Invite Code Configuration
        public const int InviteCodeLength = 8; // EX: "VIVU-ABC1"
        public const string InviteCodePrefix = "VIVU";

        // Message Pagination
        public const int MessagesPerPage = 50;

        // Device Types
        public const string DeviceType_Web = "web";
        public const string DeviceType_iOS = "ios";
        public const string DeviceType_Android = "android";

        // Notification Types 
        public const string NotificationType_OwnerAnnouncement = "OwnerAnnouncement";

    }
}

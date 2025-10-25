namespace vivuvn_api.Extensions
{
    public static class ConfigurationExtenstions
    {
        public static void ReplaceDockerEnvironmentVariables(this WebApplicationBuilder builder)
        {
            if (builder.Environment.EnvironmentName != "Docker")
                return;

            var config = builder.Configuration;

            void ReplaceIfContains(string key, string envVar, string? defaultValue = null)
            {
                var currentValue = config[key];
                if (!string.IsNullOrEmpty(currentValue) && currentValue.Contains("${" + envVar + "}"))
                {
                    var envValue = Environment.GetEnvironmentVariable(envVar) ?? defaultValue;
                    if (!string.IsNullOrEmpty(envValue))
                    {
                        var newValue = currentValue.Replace("${" + envVar + "}", envValue);
                        builder.Configuration[key] = newValue;
                    }
                }
            }

            // Replace SQL connection string password
            ReplaceIfContains("ConnectionStrings:DefaultConnectionString", "SA_PASSWORD", "VivuVN@123456");

            // Replace JWT settings
            ReplaceIfContains("JWT:Key", "JWT_SECRET_KEY");
            ReplaceIfContains("JWT:Issuer", "JWT_ISSUER");
            ReplaceIfContains("JWT:Audience", "JWT_AUDIENCE");

            // Replace Brevo API settings
            ReplaceIfContains("BrevoApi:ApiKey", "BREVO_API_KEY");
            ReplaceIfContains("BrevoApi:SenderEmail", "BREVO_SENDER_EMAIL");

            // VIVUVN Clients settings
            ReplaceIfContains("VivuvnClients:AdminPanel", "ADMIN_PANEL_URL", "http://localhost:3001");

            // AI Service settings
            ReplaceIfContains("AiService:BaseUrl", "AI_SERVICE_BASE_URL");

            // Replace Google services settings
            ReplaceIfContains("GoogleMapService:ApiKey", "GOOGLE_MAPS_API_KEY");
            ReplaceIfContains("GoogleMapService:RouteUrl", "GOOGLE_MAPS_ROUTE_URL");
            ReplaceIfContains("GoogleMapService:PlaceUrl", "GOOGLE_MAPS_PLACE_URL");
            ReplaceIfContains("GoogleOAuth:ClientId", "GOOGLE_OAUTH_CLIENT_ID");

        }
    }
}

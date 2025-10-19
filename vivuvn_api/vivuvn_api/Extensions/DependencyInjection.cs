using Microsoft.EntityFrameworkCore;
using vivuvn_api.Data;
using vivuvn_api.Data.DbInitializer;
using vivuvn_api.Repositories.Implementations;
using vivuvn_api.Repositories.Interfaces;
using vivuvn_api.Services.Implementations;
using vivuvn_api.Services.Interfaces;

namespace vivuvn_api.Extensions
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddRepositories(this IServiceCollection services)
        {
            services.AddScoped<IUserRepository, UserRepository>();
            services.AddScoped<IItineraryRepository, ItineraryRepository>();
            services.AddScoped<IItineraryDayRepository, ItineraryDayRepository>();
            services.AddScoped<IBudgetRepository, BudgetRepository>();
            services.AddScoped<IBudgetItemRepository, BudgetItemRepository>();
            services.AddScoped<IBudgetTypeRepository, BudgetTypeRepository>();
            services.AddScoped<IProvinceRepository, ProvinceRepository>();
            services.AddScoped<ILocationRepository, LocationRepository>();
            services.AddScoped<IFavoritePlaceRepository, FavoritePlaceRepository>();
            services.AddScoped<IItineraryItemRepository, ItineraryItemRepository>();
            services.AddScoped<IAiClientService, AiClientService>();
            return services;
        }

        public static IServiceCollection AddServices(this IServiceCollection services)
        {
            services.AddScoped<IDbInitializer, DbInitializer>();
            services.AddScoped<ITokenService, TokenService>();
            services.AddScoped<IAuthService, AuthService>();
            services.AddScoped<IEmailService, EmailService>();
            services.AddScoped<IImageService, ImageService>();
            services.AddScoped<ILocationService, LocationService>();
            services.AddScoped<IUserService, UserService>();
            services.AddScoped<IItineraryService, ItineraryService>();
            services.AddScoped<IProvinceService, ProvinceService>();
            services.AddScoped<IFavoritePlaceService, FavoritePlaceService>();
            services.AddScoped<IItineraryItemService, ItineraryItemService>();
            services.AddScoped<IBudgetService, BudgetService>();
            services.AddScoped<IAiClientService, AiClientService>();
            return services;
        }

        public static IServiceCollection AddUnitOfWork(this IServiceCollection services)
        {
            services.AddScoped<IUnitOfWork, UnitOfWork>();
            return services;
        }

        public static IServiceCollection AddDatabaseContext(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddDbContext<AppDbContext>(options =>
                options.UseSqlServer(configuration.GetConnectionString("DefaultConnectionString")));
            return services;
        }

        public static IServiceCollection AddCustomHttpClient(this IServiceCollection services, IConfiguration configuration)
        {

            // AI Client
            services.AddHttpClient<IAiClientService, AiClientService>(httpClient =>
            {
                httpClient.BaseAddress = new Uri(configuration.GetValue<string>("AiService:BaseUrl") ?? "");
            });

            // Google Map Client
            services.AddHttpClient<IGoogleMapRouteService, GoogleMapRouteService>(httpClient =>
            {
                httpClient.BaseAddress = new Uri(configuration.GetValue<string>("GoogleMapService:RouteUrl") ?? "");
                httpClient.DefaultRequestHeaders.Add("Content-Type", "application/json");
                httpClient.DefaultRequestHeaders.Add("X-Goog-FieldMask", "routes.duration,routes.distanceMeters");
            });

            return services;
        }
    }
}

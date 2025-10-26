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
            services.AddScoped<IProvinceRepository, ProvinceRepository>();
            services.AddScoped<ILocationRepository, LocationRepository>();
            services.AddScoped<IFavoritePlaceRepository, FavoritePlaceRepository>();
            services.AddScoped<IItineraryItemRepository, ItineraryItemRepository>();
            services.AddScoped<IItineraryRestaurantRepository, ItineraryRestaurantRepository>();
            services.AddScoped<IItineraryHotelRepository, ItineraryHotelRepository>();
            services.AddScoped<IRestaurantRepository, RestaurantRepository>();
            services.AddScoped<IHotelRepository, HotelRepository>();
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
            services.AddScoped<IitineraryRestaurantService, ItineraryRestaurantService>();
            services.AddScoped<IitineraryHotelService, ItineraryHotelService>();
            services.AddScoped<IProvinceService, ProvinceService>();
            services.AddScoped<IFavoritePlaceService, FavoritePlaceService>();
            services.AddScoped<IItineraryItemService, ItineraryItemService>();
            services.AddScoped<IBudgetService, BudgetService>();
            services.AddScoped<IAiClientService, AiClientService>();
            services.AddScoped<IGoogleMapRouteService, GoogleMapRouteService>();
            services.AddScoped<IGoogleMapPlaceService, GoogleMapPlaceService>();
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

            // Google Route Client
            services.AddHttpClient<IGoogleMapRouteService, GoogleMapRouteService>(httpClient =>
            {
                httpClient.BaseAddress = new Uri(configuration.GetValue<string>("GoogleMapService:RouteUrl") ?? "");
            });

            // Google Place Client
            services.AddHttpClient<IGoogleMapPlaceService, GoogleMapPlaceService>(httpClient =>
            {
                httpClient.BaseAddress = new Uri(configuration.GetValue<string>("GoogleMapService:PlaceUrl") ?? "");
            });

            return services;
        }
    }
}

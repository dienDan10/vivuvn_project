using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.FileProviders;
using Microsoft.IdentityModel.Tokens;
using sib_api_v3_sdk.Client;
using vivuvn_api.Data.DbInitializer;
using vivuvn_api.Exceptions;
using vivuvn_api.Extensions;
using vivuvn_api.Filters;
using vivuvn_api.Helpers;
using vivuvn_api.Mappings;

var builder = WebApplication.CreateBuilder(args);

// Replace environment variable placeholders in configuration
if (builder.Environment.EnvironmentName == "Docker")
{
    var config = builder.Configuration;

    // Replace connection string placeholder
    var connectionString = config.GetConnectionString("DefaultConnectionString");
    if (!string.IsNullOrEmpty(connectionString) && connectionString.Contains("${SA_PASSWORD}"))
    {
        var saPassword = Environment.GetEnvironmentVariable("SA_PASSWORD") ?? "VivuVN@123456";
        connectionString = connectionString.Replace("${SA_PASSWORD}", saPassword);
        builder.Configuration["ConnectionStrings:DefaultConnectionString"] = connectionString;
    }

    // Replace JWT secret key
    var jwtKey = config["JWT:Key"];
    if (!string.IsNullOrEmpty(jwtKey) && jwtKey.Contains("${JWT_SECRET_KEY}"))
    {
        var secretKey = Environment.GetEnvironmentVariable("JWT_SECRET_KEY");
        if (!string.IsNullOrEmpty(secretKey))
        {
            builder.Configuration["JWT:Key"] = secretKey;
        }
    }

    // Replace Brevo API Key
    var brevoApiKey = config["BrevoApi:ApiKey"];
    if (!string.IsNullOrEmpty(brevoApiKey) && brevoApiKey.Contains("${BREVO_API_KEY}"))
    {
        var apiKey = Environment.GetEnvironmentVariable("BREVO_API_KEY");
        if (!string.IsNullOrEmpty(apiKey))
        {
            builder.Configuration["BrevoApi:ApiKey"] = apiKey;
        }
    }

    // Replace Brevo Sender Email
    var brevoSenderEmail = config["BrevoApi:SenderEmail"];
    if (!string.IsNullOrEmpty(brevoSenderEmail) && brevoSenderEmail.Contains("${BREVO_SENDER_EMAIL}"))
    {
        var senderEmail = Environment.GetEnvironmentVariable("BREVO_SENDER_EMAIL");
        if (!string.IsNullOrEmpty(senderEmail))
        {
            builder.Configuration["BrevoApi:SenderEmail"] = senderEmail;
        }
    }

    // Replace Google Maps API Key
    var googleMapsApiKey = config["GoogleMapService:ApiKey"];
    if (!string.IsNullOrEmpty(googleMapsApiKey) && googleMapsApiKey.Contains("${GOOGLE_MAPS_API_KEY}"))
    {
        var apiKey = Environment.GetEnvironmentVariable("GOOGLE_MAPS_API_KEY");
        if (!string.IsNullOrEmpty(apiKey))
        {
            builder.Configuration["GoogleMapService:ApiKey"] = apiKey;
        }
    }

    // Replace Google OAuth Client ID
    var googleOAuthClientId = config["GoogleOAuth:ClientId"];
    if (!string.IsNullOrEmpty(googleOAuthClientId) && googleOAuthClientId.Contains("${GOOGLE_OAUTH_CLIENT_ID}"))
    {
        var clientId = Environment.GetEnvironmentVariable("GOOGLE_OAUTH_CLIENT_ID");
        if (!string.IsNullOrEmpty(clientId))
        {
            builder.Configuration["GoogleOAuth:ClientId"] = clientId;
        }
    }
}

// Add Exception Handlers
builder.Services.AddExceptionHandler<ValidationExceptionHandler>();
builder.Services.AddExceptionHandler<GlobalExceptionHandler>();
builder.Services.AddProblemDetails();

// Add custom validation filter
builder.Services.AddControllers(options =>
{
    options.Filters.Add<ValidationFilter>();
});

builder.Services.Configure<ApiBehaviorOptions>(options =>
{
    options.SuppressModelStateInvalidFilter = true; // Disable default model state validation
});

// Add services to the container.
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddHttpContextAccessor();

// Add DB context
builder.Services.AddDatabaseContext(builder.Configuration);

// Add CORS policy
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowClientWebsite", policy =>
    {
        policy.WithOrigins(builder.Configuration["VivuvnClients:AdminPanel"] ?? "http://localhost:3001")
            .AllowAnyHeader()
            .AllowAnyMethod()
            .AllowCredentials();

    });
});

// Add JWT authentication
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ClockSkew = TimeSpan.Zero,
        ValidateIssuerSigningKey = true,
        ValidIssuer = builder.Configuration["JWT:Issuer"],
        ValidAudience = builder.Configuration["JWT:Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(builder.Configuration["JWT:Key"] ?? "default_secret_key")),
    };
});

// Add AutoMapper
builder.Services.AddAutoMapper(typeof(AutoMapperProfiles));

// configure Brevo API client
Configuration.Default.ApiKey.Add("api-key", builder.Configuration["BrevoApi:ApiKey"]);

// Configure strongly typed settings objects
builder.Services.Configure<BrevoSettings>(builder.Configuration.GetSection("BrevoApi"));

// Declare Services and Repositories
builder.Services.AddServices();
builder.Services.AddRepositories();
builder.Services.AddUnitOfWork();
builder.Services.AddCustomHttpClient(builder.Configuration);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors("AllowClientWebsite");
app.UseExceptionHandler();
app.UseAuthentication();
app.UseAuthorization();

// serving static files
app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = new PhysicalFileProvider(Path.Combine(builder.Environment.ContentRootPath, "images")),
    RequestPath = "/images"
});

// Add health check endpoint
app.MapGet("/health", () => Results.Ok(new { status = "healthy", timestamp = DateTime.UtcNow }));

app.MapControllers();

SeedDatabase();

app.Run();

void SeedDatabase()
{
    using var scope = app.Services.CreateScope();
    var dbInitializer = scope.ServiceProvider.GetRequiredService<IDbInitializer>();
    dbInitializer.Initialize();
}

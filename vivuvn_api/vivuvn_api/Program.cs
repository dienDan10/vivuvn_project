using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
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
builder.ReplaceDockerEnvironmentVariables();

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

// Initialize Firebase
var firebaseCredPath = Path.Combine(builder.Environment.ContentRootPath,
    "Secrets",
    builder.Configuration["Firebase:CredentialFile"] ?? "");

if (File.Exists(firebaseCredPath))
{
    FirebaseApp.Create(new AppOptions()
    {
        Credential = GoogleCredential.FromFile(firebaseCredPath)
    });
}
else
{
    throw new FileNotFoundException("Firebase credential file not found.", firebaseCredPath);
}

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

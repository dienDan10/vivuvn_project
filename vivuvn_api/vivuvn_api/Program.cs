using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.FileProviders;
using vivuvn_api.Data;
using vivuvn_api.Data.DbInitializer;
using vivuvn_api.Mappings;
using vivuvn_api.Services.Implementations;
using vivuvn_api.Services.Interfaces;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddHttpContextAccessor();

// Add DB context
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnectionString")));

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

// Add AutoMapper
builder.Services.AddAutoMapper(typeof(AutoMapperProfiles));

// Declare Dependency Injections
builder.Services.AddScoped<IDbInitializer, DbInitializer>();
builder.Services.AddScoped<ITokenService, TokenService>();
builder.Services.AddScoped<IAuthService, AuthService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors("AllowClientWebsite");
app.UseAuthentication();
app.UseAuthorization();

// serving static files
app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = new PhysicalFileProvider(Path.Combine(builder.Environment.ContentRootPath, "images")),
    RequestPath = "/images"
});

app.MapControllers();

SeedDatabase();

app.Run();

void SeedDatabase()
{
    using var scope = app.Services.CreateScope();
    var dbInitializer = scope.ServiceProvider.GetRequiredService<IDbInitializer>();
    dbInitializer.Initialize();
}

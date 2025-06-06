using Microsoft.EntityFrameworkCore;
using Devices.Data;


var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers(); // Add controllers only once
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger(); // Enables Swagger
    app.UseSwaggerUI(); // Enables Swagger UI for testing APIs
}

app.UseAuthorization();

app.MapControllers(); // Ensure controllers are mapped to routes

app.Run("http://0.0.0.0:5099");

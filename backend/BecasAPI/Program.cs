var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

var allowedOrigins = builder.Configuration
    .GetSection("Cors:AllowedOrigins")
    .Get<string[]>()?
    .Where(origin => !string.IsNullOrWhiteSpace(origin))
    .ToArray()
    ?? Array.Empty<string>();

if (allowedOrigins.Length == 0)
{
    allowedOrigins = new[]
    {
        "http://localhost:3000",
        "http://localhost:5173"
    };
}

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowReact", policy =>
    {
        if (allowedOrigins.Length > 0)
            policy.WithOrigins(allowedOrigins).AllowAnyHeader().AllowAnyMethod();
        else
            policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
    });
});

var app = builder.Build();

app.UseCors("AllowReact");
app.UseAuthorization();

app.MapGet("/", () => Results.Ok(new
{
    message = "Becas API activa",
    health = "/health",
    endpoint = "/api/tipoevaluacion"
}));

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.MapControllers();

// Render asigna el puerto mediante la variable de entorno PORT
var port = Environment.GetEnvironmentVariable("PORT") ?? "5000";
app.Run($"http://0.0.0.0:{port}");

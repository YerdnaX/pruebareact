var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

// CORS: agrega aquí la URL del frontend en Render una vez que la tengas
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowReact", policy =>
    {
        policy
            .WithOrigins(
                "http://localhost:3000",
                "http://localhost:5173",
                "https://tiusr15pl.cuc-carrera-ti.ac.cr"
                // "https://becas-frontend.onrender.com"  ← agregar después del primer deploy
            )
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

var app = builder.Build();

app.UseCors("AllowReact");
app.UseAuthorization();
app.MapControllers();

// Render asigna el puerto mediante la variable de entorno PORT
var port = Environment.GetEnvironmentVariable("PORT") ?? "5000";
app.Run($"http://0.0.0.0:{port}");

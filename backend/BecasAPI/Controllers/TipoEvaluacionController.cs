using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using BecasAPI.Models;

namespace BecasAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TipoEvaluacionController : ControllerBase
{
    private readonly string _connectionString;

    public TipoEvaluacionController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection")!;
    }

    // GET /api/tipoevaluacion
    [HttpGet]
    public IActionResult Get()
    {
        var lista = new List<TipoEvaluacion>();

        using var connection = new SqlConnection(_connectionString);
        connection.Open();

        var query = @"
            SELECT id_tipo_evaluacion,
                   nombre,
                   descripcion,
                   peso_ponderacion,
                   activo,
                   fecha_creacion
            FROM CAT_TipoEvaluacion
            WHERE activo = 1
            ORDER BY id_tipo_evaluacion";

        using var command = new SqlCommand(query, connection);
        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            lista.Add(new TipoEvaluacion
            {
                IdTipoEvaluacion = reader.GetInt32(0),
                Nombre           = reader.GetString(1),
                Descripcion      = reader.IsDBNull(2) ? null : reader.GetString(2),
                PesoPonderacion  = reader.GetDecimal(3),
                Activo           = reader.GetBoolean(4),
                FechaCreacion    = reader.GetDateTime(5)
            });
        }

        return Ok(lista);
    }
}

namespace BecasAPI.Models;

public class TipoEvaluacion
{
    public int IdTipoEvaluacion { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string? Descripcion { get; set; }
    public decimal PesoPonderacion { get; set; }
    public bool Activo { get; set; }
    public DateTime FechaCreacion { get; set; }
}

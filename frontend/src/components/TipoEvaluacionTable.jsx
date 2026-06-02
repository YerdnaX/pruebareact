import React, { useState, useEffect } from 'react';

const API_URL = process.env.REACT_APP_API_URL;

function TipoEvaluacionTable() {
  const [datos, setDatos] = useState([]);
  const [cargando, setCargando] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch(`${API_URL}/api/tipoevaluacion`)
      .then((response) => {
        if (!response.ok) {
          throw new Error(`Error del servidor: ${response.status}`);
        }
        return response.json();
      })
      .then((data) => {
        setDatos(data);
        setCargando(false);
      })
      .catch((err) => {
        setError(err.message);
        setCargando(false);
      });
  }, []);

  if (cargando) {
    return <p className="mensaje-carga">Cargando datos desde la base de datos...</p>;
  }

  if (error) {
    return (
      <div className="mensaje-error">
        <strong>No se pudo conectar al backend.</strong>
        <br />
        Detalle: {error}
      </div>
    );
  }

  if (datos.length === 0) {
    return <p className="mensaje-carga">No hay registros disponibles.</p>;
  }

  return (
    <table className="tabla-datos">
      <thead>
        <tr>
          <th>#</th>
          <th>Nombre</th>
          <th>Descripción</th>
          <th>Peso (%)</th>
          <th>Estado</th>
          <th>Fecha de creación</th>
        </tr>
      </thead>
      <tbody>
        {datos.map((fila) => (
          <tr key={fila.idTipoEvaluacion}>
            <td>{fila.idTipoEvaluacion}</td>
            <td>{fila.nombre}</td>
            <td>{fila.descripcion ?? '—'}</td>
            <td>{fila.pesoPonderacion}%</td>
            <td>
              <span className={fila.activo ? 'estado-activo' : 'estado-inactivo'}>
                {fila.activo ? 'Activo' : 'Inactivo'}
              </span>
            </td>
            <td>{new Date(fila.fechaCreacion).toLocaleDateString('es-CR')}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

export default TipoEvaluacionTable;

import React from 'react';
import TipoEvaluacionTable from './components/TipoEvaluacionTable';
import './App.css';

function App() {
  return (
    <div className="contenedor">
      <header className="encabezado">
        <h1>Sistema de Becas Universitarias</h1>
        <p>Tipos de Evaluación registrados en la base de datos</p>
      </header>

      <main>
        <TipoEvaluacionTable />
      </main>

      <footer className="pie">
        <p>Datos obtenidos desde SQL Server vía API .NET &mdash; Semana 03</p>
      </footer>
    </div>
  );
}

export default App;

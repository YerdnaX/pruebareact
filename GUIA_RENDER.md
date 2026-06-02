# Guia de despliegue en Render

Este proyecto se publica como dos servicios separados:

1. `becas-api`: backend ASP.NET Core.
2. `becas-frontend`: sitio estatico de React.

## 1. Antes de desplegar

- Confirma que la base de datos SQL Server sea accesible desde Internet.
- Verifica que el firewall del servidor SQL permita conexiones salientes desde Render.
- Si la cadena de conexion ya estuvo en GitHub, cambiala por seguridad.

## 2. Backend en Render

Tipo de servicio: `Web Service`

Configuracion principal:

- Root Directory: `backend/BecasAPI`
- Environment: `.NET`
- Build Command: `dotnet publish -c Release -o out`
- Start Command: `dotnet out/BecasAPI.dll`

Variables de entorno:

- `ConnectionStrings__DefaultConnection`
- `Cors__AllowedOrigins__0`

Ejemplo de `Cors__AllowedOrigins__0`:

```text
https://tu-frontend-en-render.onrender.com
```

## 3. Frontend en Render

Tipo de servicio: `Static Site`

Configuracion principal:

- Root Directory: `frontend`
- Build Command: `npm install ; npm run build`
- Publish Directory: `build`

Variable de entorno requerida:

- `REACT_APP_API_URL`

Ejemplo:

```text
https://tu-backend-en-render.onrender.com
```

## 4. Orden recomendado

1. Publica primero el backend.
2. Copia la URL publica del backend.
3. Crea el frontend y asigna `REACT_APP_API_URL` con esa URL.
4. Copia la URL publica del frontend.
5. Regresa al backend y configura `Cors__AllowedOrigins__0` con la URL del frontend.
6. Redeploy del backend.

## 5. Despliegue con Blueprint opcional

El archivo `render.yaml` permite crear ambos servicios desde el repositorio.

Pasos:

1. En Render, elige `New +`.
2. Selecciona `Blueprint`.
3. Conecta tu repositorio de GitHub.
4. Render leera `render.yaml` y te pedira los valores sensibles.

## 6. Pruebas despues del despliegue

- Backend: abre `/health`.
- Backend: abre `/api/tipoevaluacion`.
- Frontend: verifica que cargue la tabla sin errores.

## 7. Problemas comunes

- Error CORS: la URL del frontend no esta registrada en `Cors__AllowedOrigins__0`.
- Error 500 en backend: la cadena `ConnectionStrings__DefaultConnection` esta incorrecta o la tabla no existe.
- Frontend vacio o con error de red: `REACT_APP_API_URL` apunta a una URL equivocada.
- Build fallido en frontend: faltan dependencias o el `package-lock.json` no coincide.
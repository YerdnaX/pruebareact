-- ============================================================
--  SISTEMA INTEGRAL DE GESTIÓN DE BECAS UNIVERSITARIAS
--  Módulo: Evaluación Socioeconómica, Académica y Técnica
--  Script: Creación de tablas SQL Server
--  Versión: 1.0
-- ============================================================

USE BecasDB;
GO

-- ============================================================
-- CATÁLOGOS BASE
-- ============================================================

CREATE TABLE CAT_TipoEvaluacion (
    id_tipo_evaluacion      INT             IDENTITY(1,1) PRIMARY KEY,
    nombre                  NVARCHAR(100)   NOT NULL,
    descripcion             NVARCHAR(300)   NULL,
    peso_ponderacion        DECIMAL(5,2)    NOT NULL CHECK (peso_ponderacion BETWEEN 0 AND 100),
    activo                  BIT             NOT NULL DEFAULT 1,
    fecha_creacion          DATETIME2       NOT NULL DEFAULT GETDATE(),
    usuario_creacion        NVARCHAR(100)   NOT NULL
);
GO

CREATE TABLE CAT_TipoEntrevista (
    id_tipo_entrevista      INT             IDENTITY(1,1) PRIMARY KEY,
    nombre                  NVARCHAR(100)   NOT NULL,
    descripcion             NVARCHAR(300)   NULL,
    rol_responsable         NVARCHAR(100)   NOT NULL,
    obligatoria_defecto     BIT             NOT NULL DEFAULT 0,
    activo                  BIT             NOT NULL DEFAULT 1,
    fecha_creacion          DATETIME2       NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE CAT_NivelVulnerabilidad (
    id_nivel                INT             IDENTITY(1,1) PRIMARY KEY,
    codigo                  NVARCHAR(20)    NOT NULL UNIQUE,
    descripcion             NVARCHAR(100)   NOT NULL,
    valor_puntaje           DECIMAL(5,2)    NOT NULL,
    activo                  BIT             NOT NULL DEFAULT 1
);
GO

CREATE TABLE CAT_EstadoEvaluacion (
    id_estado               INT             IDENTITY(1,1) PRIMARY KEY,
    codigo                  NVARCHAR(50)    NOT NULL UNIQUE,
    descripcion             NVARCHAR(200)   NOT NULL,
    activo                  BIT             NOT NULL DEFAULT 1
);
GO

CREATE TABLE CAT_EstadoSolicitud (
    id_estado               INT             IDENTITY(1,1) PRIMARY KEY,
    codigo                  NVARCHAR(50)    NOT NULL UNIQUE,
    descripcion             NVARCHAR(200)   NOT NULL,
    permite_evaluacion      BIT             NOT NULL DEFAULT 0,
    activo                  BIT             NOT NULL DEFAULT 1
);
GO

CREATE TABLE CAT_ResultadoEntrevista (
    id_resultado            INT             IDENTITY(1,1) PRIMARY KEY,
    codigo                  NVARCHAR(30)    NOT NULL UNIQUE,  -- FAVORABLE, DESFAVORABLE, CONDICIONADO
    descripcion             NVARCHAR(100)   NOT NULL,
    activo                  BIT             NOT NULL DEFAULT 1
);
GO

CREATE TABLE CAT_TipoVivienda (
    id_tipo_vivienda        INT             IDENTITY(1,1) PRIMARY KEY,
    descripcion             NVARCHAR(100)   NOT NULL,
    activo                  BIT             NOT NULL DEFAULT 1
);
GO

CREATE TABLE CAT_SituacionLaboral (
    id_situacion            INT             IDENTITY(1,1) PRIMARY KEY,
    descripcion             NVARCHAR(100)   NOT NULL,
    activo                  BIT             NOT NULL DEFAULT 1
);
GO

-- ============================================================
-- CONFIGURACIÓN DE PARÁMETROS DEL SISTEMA
-- ============================================================

CREATE TABLE CFG_ParametrosSistema (
    id_parametro            INT             IDENTITY(1,1) PRIMARY KEY,
    clave                   NVARCHAR(100)   NOT NULL UNIQUE,
    valor                   NVARCHAR(500)   NOT NULL,
    descripcion             NVARCHAR(300)   NULL,
    tipo_dato               NVARCHAR(30)    NOT NULL,  -- DECIMAL, ENTERO, TEXTO, FECHA
    modulo                  NVARCHAR(100)   NOT NULL,
    activo                  BIT             NOT NULL DEFAULT 1,
    fecha_modificacion      DATETIME2       NOT NULL DEFAULT GETDATE(),
    usuario_modificacion    NVARCHAR(100)   NOT NULL
);
GO

-- ============================================================
-- MOTOR DE REGLAS DE NEGOCIO
-- ============================================================

CREATE TABLE REG_ReglaElegibilidad (
    id_regla                INT             IDENTITY(1,1) PRIMARY KEY,
    nombre                  NVARCHAR(150)   NOT NULL,
    descripcion             NVARCHAR(500)   NULL,
    campo_condicion         NVARCHAR(100)   NOT NULL,
    operador                NVARCHAR(20)    NOT NULL CHECK (operador IN ('>', '<', '>=', '<=', '=', '!=', 'IN', 'NOT IN')),
    valor_umbral            NVARCHAR(200)   NOT NULL,
    operador_logico         NVARCHAR(10)    NULL CHECK (operador_logico IN ('AND', 'OR', 'NOT', NULL)),
    accion_resultado        NVARCHAR(50)    NOT NULL,  -- RECHAZAR, PENDIENTE, PRIORIDAD_ALTA, ELEGIBLE
    estado_resultante       NVARCHAR(50)    NOT NULL,
    mensaje_respuesta       NVARCHAR(500)   NOT NULL,
    prioridad               INT             NOT NULL DEFAULT 1,
    version                 INT             NOT NULL DEFAULT 1,
    activo                  BIT             NOT NULL DEFAULT 1,
    fecha_creacion          DATETIME2       NOT NULL DEFAULT GETDATE(),
    usuario_creacion        NVARCHAR(100)   NOT NULL,
    fecha_modificacion      DATETIME2       NULL,
    usuario_modificacion    NVARCHAR(100)   NULL
);
GO

CREATE TABLE REG_VersionRegla (
    id_version              INT             IDENTITY(1,1) PRIMARY KEY,
    id_regla                INT             NOT NULL REFERENCES REG_ReglaElegibilidad(id_regla),
    version                 INT             NOT NULL,
    configuracion_json      NVARCHAR(MAX)   NOT NULL,  -- snapshot de la regla en esa versión
    cambios_realizados      NVARCHAR(1000)  NOT NULL,
    usuario_cambio          NVARCHAR(100)   NOT NULL,
    fecha_cambio            DATETIME2       NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE REG_EjecucionRegla (
    id_ejecucion            INT             IDENTITY(1,1) PRIMARY KEY,
    id_regla                INT             NOT NULL REFERENCES REG_ReglaElegibilidad(id_regla),
    id_solicitud            INT             NOT NULL,
    condicion_evaluada      NVARCHAR(500)   NOT NULL,
    valor_encontrado        NVARCHAR(200)   NOT NULL,
    resultado               NVARCHAR(50)    NOT NULL,
    estado_asignado         NVARCHAR(50)    NOT NULL,
    es_simulacion           BIT             NOT NULL DEFAULT 0,
    fecha_ejecucion         DATETIME2       NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- EXPEDIENTE DE EVALUACIÓN
-- ============================================================

CREATE TABLE EVA_ExpedienteEvaluacion (
    id_expediente           INT             IDENTITY(1,1) PRIMARY KEY,
    id_solicitud            INT             NOT NULL UNIQUE,
    id_estudiante           NVARCHAR(50)    NOT NULL,
    id_convocatoria         INT             NOT NULL,
    id_estado               INT             NOT NULL REFERENCES CAT_EstadoEvaluacion(id_estado),
    puntaje_academico       DECIMAL(6,2)    NULL CHECK (puntaje_academico BETWEEN 0 AND 100),
    puntaje_socioeconomico  DECIMAL(6,2)    NULL CHECK (puntaje_socioeconomico BETWEEN 0 AND 100),
    puntaje_vulnerabilidad  DECIMAL(6,2)    NULL CHECK (puntaje_vulnerabilidad BETWEEN 0 AND 100),
    puntaje_meritos         DECIMAL(6,2)    NULL CHECK (puntaje_meritos BETWEEN 0 AND 100),
    puntaje_total           AS (
                                COALESCE(puntaje_academico,0)       * 0.35 +
                                COALESCE(puntaje_socioeconomico,0)  * 0.40 +
                                COALESCE(puntaje_vulnerabilidad,0)  * 0.15 +
                                COALESCE(puntaje_meritos,0)         * 0.10
                            ) PERSISTED,
    posicion_ranking        INT             NULL,
    es_prioridad_alta       BIT             NOT NULL DEFAULT 0,
    evaluacion_completa     BIT             NOT NULL DEFAULT 0,
    fecha_inicio_evaluacion DATETIME2       NOT NULL DEFAULT GETDATE(),
    fecha_cierre_evaluacion DATETIME2       NULL,
    usuario_cierre          NVARCHAR(100)   NULL,
    observaciones_generales NVARCHAR(MAX)   NULL,
    fecha_creacion          DATETIME2       NOT NULL DEFAULT GETDATE(),
    usuario_creacion        NVARCHAR(100)   NOT NULL
);
GO

-- ============================================================
-- EVALUACIÓN ACADÉMICA (datos del ERP integrado)
-- ============================================================

CREATE TABLE EVA_DatosAcademicos (
    id_datos_academicos     INT             IDENTITY(1,1) PRIMARY KEY,
    id_expediente           INT             NOT NULL UNIQUE REFERENCES EVA_ExpedienteEvaluacion(id_expediente),
    promedio_general        DECIMAL(5,2)    NOT NULL,
    cantidad_reprobaciones  INT             NOT NULL DEFAULT 0,
    avance_curricular_pct   DECIMAL(5,2)    NOT NULL CHECK (avance_curricular_pct BETWEEN 0 AND 100),
    creditos_matriculados   INT             NOT NULL,
    estado_academico        NVARCHAR(50)    NOT NULL,
    tiene_sancion_activa    BIT             NOT NULL DEFAULT 0,
    detalle_sancion         NVARCHAR(500)   NULL,
    reconocimientos         NVARCHAR(MAX)   NULL,
    carrera                 NVARCHAR(200)   NOT NULL,
    facultad                NVARCHAR(200)   NOT NULL,
    sede                    NVARCHAR(200)   NOT NULL,
    fuente_datos            NVARCHAR(100)   NOT NULL DEFAULT 'ERP_ACADEMICO',
    fecha_consulta_erp      DATETIME2       NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- FICHA DE EVALUACIÓN SOCIOECONÓMICA
-- ============================================================

CREATE TABLE EVA_FichaSocioeconomica (
    id_ficha                INT             IDENTITY(1,1) PRIMARY KEY,
    id_expediente           INT             NOT NULL UNIQUE REFERENCES EVA_ExpedienteEvaluacion(id_expediente),
    ingreso_familiar_total  DECIMAL(12,2)   NOT NULL CHECK (ingreso_familiar_total >= 0),
    numero_dependientes     INT             NOT NULL CHECK (numero_dependientes >= 0),
    ingreso_per_capita      AS (
                                CASE WHEN numero_dependientes > 0
                                THEN ingreso_familiar_total / numero_dependientes
                                ELSE ingreso_familiar_total END
                            ) PERSISTED,
    id_tipo_vivienda        INT             NOT NULL REFERENCES CAT_TipoVivienda(id_tipo_vivienda),
    gastos_mensuales        DECIMAL(12,2)   NOT NULL CHECK (gastos_mensuales >= 0),
    id_situacion_laboral    INT             NOT NULL REFERENCES CAT_SituacionLaboral(id_situacion),
    id_nivel_vulnerabilidad INT             NOT NULL REFERENCES CAT_NivelVulnerabilidad(id_nivel),
    tiene_discapacidad      BIT             NOT NULL DEFAULT 0,
    detalle_discapacidad    NVARCHAR(500)   NULL,
    condicion_medica        NVARCHAR(500)   NULL,
    validado_visita         BIT             NOT NULL DEFAULT 0,
    puntaje_calculado       DECIMAL(6,2)    NULL CHECK (puntaje_calculado BETWEEN 0 AND 100),
    trabajador_social       NVARCHAR(100)   NOT NULL,
    fecha_evaluacion        DATE            NOT NULL,
    observaciones           NVARCHAR(MAX)   NULL,
    fecha_registro          DATETIME2       NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- ENTREVISTAS
-- ============================================================

CREATE TABLE EVA_Entrevista (
    id_entrevista           INT             IDENTITY(1,1) PRIMARY KEY,
    id_expediente           INT             NOT NULL REFERENCES EVA_ExpedienteEvaluacion(id_expediente),
    id_tipo_entrevista      INT             NOT NULL REFERENCES CAT_TipoEntrevista(id_tipo_entrevista),
    fecha_hora_entrevista   DATETIME2       NOT NULL,
    evaluador_usuario       NVARCHAR(100)   NOT NULL,
    puntaje_asignado        DECIMAL(6,2)    NOT NULL CHECK (puntaje_asignado BETWEEN 0 AND 100),
    id_resultado            INT             NOT NULL REFERENCES CAT_ResultadoEntrevista(id_resultado),
    observaciones           NVARCHAR(MAX)   NULL,
    ruta_informe_pdf        NVARCHAR(500)   NULL,
    fecha_registro_sistema  DATETIME2       NOT NULL DEFAULT GETDATE(),
    CONSTRAINT UK_entrevista_tipo UNIQUE (id_expediente, id_tipo_entrevista)
);
GO

-- ============================================================
-- VISITA DOMICILIAR
-- ============================================================

CREATE TABLE EVA_VisitaDomiciliar (
    id_visita               INT             IDENTITY(1,1) PRIMARY KEY,
    id_expediente           INT             NOT NULL REFERENCES EVA_ExpedienteEvaluacion(id_expediente),
    fecha_visita            DATE            NOT NULL,
    trabajador_social       NVARCHAR(100)   NOT NULL,
    condiciones_hogar       NVARCHAR(MAX)   NOT NULL,
    datos_confirmados       BIT             NOT NULL DEFAULT 1,
    discrepancias_encontradas NVARCHAR(MAX) NULL,
    ruta_documentos_soporte NVARCHAR(500)   NULL,
    fecha_registro          DATETIME2       NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- RANKING DE CANDIDATOS
-- ============================================================

CREATE TABLE EVA_Ranking (
    id_ranking              INT             IDENTITY(1,1) PRIMARY KEY,
    id_convocatoria         INT             NOT NULL,
    id_expediente           INT             NOT NULL REFERENCES EVA_ExpedienteEvaluacion(id_expediente),
    posicion                INT             NOT NULL,
    puntaje_total           DECIMAL(6,2)    NOT NULL,
    congelado               BIT             NOT NULL DEFAULT 0,
    fecha_generacion        DATETIME2       NOT NULL DEFAULT GETDATE(),
    usuario_generacion      NVARCHAR(100)   NOT NULL,
    fecha_congelamiento     DATETIME2       NULL,
    usuario_congelamiento   NVARCHAR(100)   NULL,
    CONSTRAINT UK_ranking_posicion UNIQUE (id_convocatoria, posicion)
);
GO

-- ============================================================
-- RESOLUCIÓN DEL COMITÉ
-- ============================================================

CREATE TABLE COM_ResolucionComite (
    id_resolucion           INT             IDENTITY(1,1) PRIMARY KEY,
    numero_resolucion       NVARCHAR(50)    NOT NULL UNIQUE,
    id_expediente           INT             NOT NULL REFERENCES EVA_ExpedienteEvaluacion(id_expediente),
    id_convocatoria         INT             NOT NULL,
    estado_resolucion       NVARCHAR(50)    NOT NULL CHECK (estado_resolucion IN ('APROBADA','CONDICIONADA','LISTA_ESPERA','RECHAZADA')),
    porcentaje_beneficio    DECIMAL(5,2)    NULL CHECK (porcentaje_beneficio IN (25, 50, 75, 100)),
    causal_rechazo          NVARCHAR(500)   NULL,
    firmada                 BIT             NOT NULL DEFAULT 0,
    fecha_firma             DATETIME2       NULL,
    ruta_pdf_resolucion     NVARCHAR(500)   NULL,
    fecha_notificacion      DATETIME2       NULL,
    observaciones           NVARCHAR(MAX)   NULL,
    fecha_creacion          DATETIME2       NOT NULL DEFAULT GETDATE(),
    usuario_creacion        NVARCHAR(100)   NOT NULL
);
GO

CREATE TABLE COM_ActaSesion (
    id_acta                 INT             IDENTITY(1,1) PRIMARY KEY,
    id_convocatoria         INT             NOT NULL,
    fecha_sesion            DATETIME2       NOT NULL,
    participantes           NVARCHAR(MAX)   NOT NULL,
    acuerdos                NVARCHAR(MAX)   NOT NULL,
    ruta_pdf_acta           NVARCHAR(500)   NULL,
    usuario_generacion      NVARCHAR(100)   NOT NULL,
    fecha_generacion        DATETIME2       NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- AUDITORÍA
-- ============================================================

CREATE TABLE AUD_BitacoraEvaluacion (
    id_bitacora             INT             IDENTITY(1,1) PRIMARY KEY,
    tabla_afectada          NVARCHAR(100)   NOT NULL,
    id_registro             INT             NOT NULL,
    accion                  NVARCHAR(20)    NOT NULL CHECK (accion IN ('INSERT','UPDATE','DELETE','SELECT')),
    campo_modificado        NVARCHAR(100)   NULL,
    valor_anterior          NVARCHAR(MAX)   NULL,
    valor_nuevo             NVARCHAR(MAX)   NULL,
    justificacion           NVARCHAR(1000)  NULL,
    ip_cliente              NVARCHAR(50)    NULL,
    usuario_sistema         NVARCHAR(100)   NOT NULL,
    fecha_hora              DATETIME2       NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE AUD_LogIntegracion (
    id_log                  INT             IDENTITY(1,1) PRIMARY KEY,
    servicio_externo        NVARCHAR(100)   NOT NULL,
    id_estudiante           NVARCHAR(50)    NULL,
    endpoint_consultado     NVARCHAR(500)   NOT NULL,
    datos_enviados          NVARCHAR(MAX)   NULL,
    respuesta_recibida      NVARCHAR(MAX)   NULL,
    codigo_respuesta        NVARCHAR(10)    NULL,
    exitoso                 BIT             NOT NULL,
    tiempo_respuesta_ms     INT             NULL,
    mensaje_error           NVARCHAR(500)   NULL,
    fecha_hora              DATETIME2       NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- ÍNDICES
-- ============================================================

CREATE INDEX IX_ExpedienteEvaluacion_Solicitud  ON EVA_ExpedienteEvaluacion(id_solicitud);
CREATE INDEX IX_ExpedienteEvaluacion_Convocatoria ON EVA_ExpedienteEvaluacion(id_convocatoria);
CREATE INDEX IX_ExpedienteEvaluacion_Estudiante  ON EVA_ExpedienteEvaluacion(id_estudiante);
CREATE INDEX IX_ExpedienteEvaluacion_Estado      ON EVA_ExpedienteEvaluacion(id_estado);
CREATE INDEX IX_Entrevista_Expediente            ON EVA_Entrevista(id_expediente);
CREATE INDEX IX_EjecucionRegla_Solicitud         ON REG_EjecucionRegla(id_solicitud);
CREATE INDEX IX_EjecucionRegla_Regla             ON REG_EjecucionRegla(id_regla);
CREATE INDEX IX_Ranking_Convocatoria             ON EVA_Ranking(id_convocatoria);
CREATE INDEX IX_ResolucionComite_Expediente      ON COM_ResolucionComite(id_expediente);
CREATE INDEX IX_Bitacora_Tabla_Registro          ON AUD_BitacoraEvaluacion(tabla_afectada, id_registro);
CREATE INDEX IX_Bitacora_Fecha                   ON AUD_BitacoraEvaluacion(fecha_hora);
GO

PRINT 'Tablas del módulo de Evaluación creadas exitosamente.';
GO

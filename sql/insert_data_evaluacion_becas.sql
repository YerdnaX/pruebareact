-- ============================================================
--  SISTEMA INTEGRAL DE GESTIÓN DE BECAS UNIVERSITARIAS
--  Módulo: Evaluación Socioeconómica, Académica y Técnica
--  Script: Inserción de datos de prueba / catálogos base
--  Versión: 1.0
-- ============================================================

USE BecasDB;
GO

-- ============================================================
-- 1. CATÁLOGOS BASE
-- ============================================================

-- Tipos de Evaluación (ponderaciones)
INSERT INTO CAT_TipoEvaluacion (nombre, descripcion, peso_ponderacion, activo, usuario_creacion)
VALUES
    ('Evaluación Socioeconómica',    'Análisis de la situación económica y familiar del solicitante', 40.00, 1, 'SISTEMA'),
    ('Evaluación Académica',         'Análisis del rendimiento y avance académico del estudiante',    35.00, 1, 'SISTEMA'),
    ('Nivel de Vulnerabilidad',      'Clasificación del grado de vulnerabilidad del solicitante',     15.00, 1, 'SISTEMA'),
    ('Méritos Institucionales',      'Reconocimientos académicos, deportivos o culturales',           10.00, 1, 'SISTEMA');
GO

-- Tipos de Entrevista
INSERT INTO CAT_TipoEntrevista (nombre, descripcion, rol_responsable, obligatoria_defecto)
VALUES
    ('Entrevista Psicológica',    'Evaluación del estado emocional y psicológico del solicitante', 'PSICOLOGO',           0),
    ('Entrevista de Trabajo Social','Evaluación socioeconómica y condiciones familiares',           'TRABAJADOR_SOCIAL',   1),
    ('Entrevista Académica',      'Revisión del historial y motivación académica del estudiante',   'COORDINADOR_BECAS',   0),
    ('Visita Domiciliar',         'Verificación en campo de las condiciones del hogar',             'TRABAJADOR_SOCIAL',   0);
GO

-- Niveles de Vulnerabilidad
INSERT INTO CAT_NivelVulnerabilidad (codigo, descripcion, valor_puntaje)
VALUES
    ('ALTO',   'Vulnerabilidad alta: condiciones económicas y sociales críticas',  95.00),
    ('MEDIO',  'Vulnerabilidad media: condiciones económicas moderadamente bajas', 65.00),
    ('BAJO',   'Vulnerabilidad baja: condiciones económicas básicas cubiertas',    30.00);
GO

-- Estados de Evaluación
INSERT INTO CAT_EstadoEvaluacion (codigo, descripcion, activo)
VALUES
    ('EN_PROCESO',          'La evaluación está siendo registrada por los evaluadores',      1),
    ('COMPLETA',            'Todos los componentes del puntaje han sido registrados',        1),
    ('INCOMPLETA',          'Faltan componentes de evaluación por registrar',                1),
    ('EN_COMITE',           'El expediente fue trasladado al Comité de Becas',               1),
    ('RESUELTA',            'El Comité emitió resolución sobre esta evaluación',             1);
GO

-- Estados de Solicitud
INSERT INTO CAT_EstadoSolicitud (codigo, descripcion, permite_evaluacion)
VALUES
    ('BORRADOR',                'Solicitud iniciada pero no enviada por el estudiante',          0),
    ('ENVIADA',                 'Solicitud enviada formalmente por el estudiante',               0),
    ('EN_REVISION_DOCUMENTAL',  'El analista está revisando los documentos del expediente',     0),
    ('PENDIENTE_SUBSANACION',   'Se solicitaron correcciones al estudiante',                    0),
    ('ELEGIBLE',                'La solicitud cumple los requisitos mínimos de elegibilidad',   1),
    ('EN_EVALUACION',           'El proceso de evaluación multidimensional está en curso',      1),
    ('EN_COMITE',               'Expediente en revisión por el Comité de Becas',                0),
    ('APROBADA',                'La beca fue otorgada por el Comité de Becas',                  0),
    ('CONDICIONADA',            'Beca aprobada con condiciones específicas',                    0),
    ('LISTA_ESPERA',            'Candidato en lista de espera por cupo',                        0),
    ('RECHAZADA',               'Solicitud no fue aprobada',                                    0),
    ('FORMALIZADA',             'El estudiante firmó el convenio de beca',                      0),
    ('ACTIVA',                  'El beneficio de beca está vigente',                            0),
    ('CANCELADA',               'El beneficio fue cancelado',                                   0),
    ('CERRADA',                 'Expediente finalizado y archivado',                            0);
GO

-- Resultados de Entrevista
INSERT INTO CAT_ResultadoEntrevista (codigo, descripcion)
VALUES
    ('FAVORABLE',      'La entrevista resultó favorable para el solicitante'),
    ('DESFAVORABLE',   'La entrevista resultó desfavorable para el solicitante'),
    ('CONDICIONADO',   'El resultado es favorable con condiciones o reservas');
GO

-- Tipos de Vivienda
INSERT INTO CAT_TipoVivienda (descripcion)
VALUES
    ('Propia pagada'),
    ('Propia con hipoteca'),
    ('Alquilada'),
    ('Prestada / cedida'),
    ('Familiar compartida'),
    ('Otro');
GO

-- Situaciones Laborales
INSERT INTO CAT_SituacionLaboral (descripcion)
VALUES
    ('Empleado formal con seguro social'),
    ('Empleado informal'),
    ('Trabajo independiente / cuenta propia'),
    ('Desempleado'),
    ('Pensionado o jubilado'),
    ('Mixto (varios miembros con diferente situación)');
GO

-- ============================================================
-- 2. PARÁMETROS DEL SISTEMA
-- ============================================================

INSERT INTO CFG_ParametrosSistema (clave, valor, descripcion, tipo_dato, modulo, usuario_modificacion)
VALUES
    ('PROMEDIO_MINIMO_ELEGIBILIDAD',     '70',    'Promedio académico mínimo para ser elegible (escala 0-100)',   'DECIMAL',  'EVALUACION', 'ADMIN'),
    ('INGRESO_FAMILIAR_MAXIMO',          '800000','Ingreso familiar máximo para prioridad alta (colones)',        'DECIMAL',  'EVALUACION', 'ADMIN'),
    ('AVANCE_CURRICULAR_MINIMO_PCT',     '30',    'Porcentaje mínimo de avance curricular requerido',            'DECIMAL',  'EVALUACION', 'ADMIN'),
    ('CREDITOS_MINIMOS_MATRICULADOS',    '9',     'Créditos mínimos matriculados en el período actual',          'ENTERO',   'EVALUACION', 'ADMIN'),
    ('REPROBACIONES_MAXIMAS_PERMITIDAS', '4',     'Número máximo de reprobaciones en el historial académico',    'ENTERO',   'EVALUACION', 'ADMIN'),
    ('VIGENCIA_MAXIMA_DOCUMENTOS_DIAS',  '90',    'Días máximos desde la emisión de un documento para aceptarlo','ENTERO',   'DOCUMENTOS', 'ADMIN'),
    ('PLAZO_SUBSANACION_DIAS_HABILES',   '5',     'Días hábiles para que el estudiante corrija documentos',      'ENTERO',   'DOCUMENTOS', 'ADMIN'),
    ('PESO_EVALUACION_SOCIOECONOMICA',   '40',    'Peso porcentual de la evaluación socioeconómica',             'DECIMAL',  'EVALUACION', 'ADMIN'),
    ('PESO_EVALUACION_ACADEMICA',        '35',    'Peso porcentual de la evaluación académica',                  'DECIMAL',  'EVALUACION', 'ADMIN'),
    ('PESO_VULNERABILIDAD',              '15',    'Peso porcentual del componente de vulnerabilidad',            'DECIMAL',  'EVALUACION', 'ADMIN'),
    ('PESO_MERITOS',                     '10',    'Peso porcentual del componente de méritos',                   'DECIMAL',  'EVALUACION', 'ADMIN'),
    ('TIEMPO_MAX_VALIDACION_SEG',        '30',    'Tiempo máximo en segundos para la validación automática',     'ENTERO',   'EVALUACION', 'ADMIN'),
    ('HORAS_MAX_NOTIFICACION_RESOLUCION','24',    'Horas máximas para notificar al estudiante tras resolución',  'ENTERO',   'COMITE',     'ADMIN');
GO

-- ============================================================
-- 3. REGLAS DE NEGOCIO (Motor de Reglas)
-- ============================================================

INSERT INTO REG_ReglaElegibilidad
    (nombre, descripcion, campo_condicion, operador, valor_umbral, accion_resultado, estado_resultante, mensaje_respuesta, prioridad, usuario_creacion)
VALUES
    (
        'Rechazo por promedio mínimo',
        'Rechaza automáticamente solicitudes con promedio inferior al mínimo configurado',
        'promedio_general', '<', '70',
        'RECHAZAR', 'RECHAZADA',
        'Su solicitud no cumple el promedio académico mínimo requerido de 70 puntos.',
        1, 'ADMIN'
    ),
    (
        'Rechazo por créditos insuficientes',
        'Rechaza solicitudes con créditos matriculados menores al mínimo',
        'creditos_matriculados', '<', '9',
        'RECHAZAR', 'RECHAZADA',
        'Su solicitud no cumple la carga académica mínima requerida (9 créditos).',
        2, 'ADMIN'
    ),
    (
        'Rechazo por exceso de reprobaciones',
        'Rechaza solicitudes con historial de reprobaciones superior al máximo permitido',
        'cantidad_reprobaciones', '>', '4',
        'RECHAZAR', 'RECHAZADA',
        'Su expediente académico supera el número máximo de reprobaciones permitidas.',
        3, 'ADMIN'
    ),
    (
        'Documentos incompletos — pendiente subsanación',
        'Solicita corrección cuando el expediente no tiene todos los documentos requeridos',
        'documentos_completos', '=', 'false',
        'PENDIENTE', 'PENDIENTE_SUBSANACION',
        'Su expediente tiene documentos faltantes o incorrectos. Por favor revise el detalle y realice las correcciones indicadas.',
        4, 'ADMIN'
    ),
    (
        'Sanción disciplinaria activa',
        'Rechaza solicitudes de estudiantes con sanción disciplinaria activa',
        'tiene_sancion_activa', '=', 'true',
        'RECHAZAR', 'RECHAZADA',
        'Usted tiene una sanción disciplinaria activa que impide la aplicación a beca en este período.',
        5, 'ADMIN'
    ),
    (
        'Prioridad alta socioeconómica',
        'Asigna prioridad alta cuando el ingreso familiar está por debajo del umbral',
        'ingreso_familiar_total', '<', '800000',
        'PRIORIDAD_ALTA', 'ELEGIBLE',
        'Su solicitud ha sido marcada con prioridad alta socioeconómica.',
        6, 'ADMIN'
    ),
    (
        'Solicitud duplicada',
        'Rechaza solicitudes cuando ya existe una activa del mismo tipo en el mismo período',
        'solicitud_duplicada', '=', 'true',
        'RECHAZAR', 'RECHAZADA',
        'Usted ya tiene una solicitud activa para este tipo de beca en el período vigente.',
        7, 'ADMIN'
    ),
    (
        'Documento con vigencia vencida',
        'Solicita subsanación cuando algún documento supera los días de vigencia configurados',
        'documento_vigencia_vencida', '=', 'true',
        'PENDIENTE', 'PENDIENTE_SUBSANACION',
        'Uno o más documentos de su expediente tienen fecha de emisión superior a la permitida. Por favor actualícelos.',
        8, 'ADMIN'
    );
GO

-- Guardar versión inicial de las reglas
INSERT INTO REG_VersionRegla (id_regla, version, configuracion_json, cambios_realizados, usuario_cambio)
SELECT
    id_regla,
    1,
    (SELECT * FROM REG_ReglaElegibilidad r2 WHERE r2.id_regla = r.id_regla FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
    'Creación inicial de la regla',
    'ADMIN'
FROM REG_ReglaElegibilidad r;
GO

-- ============================================================
-- 4. DATOS DE PRUEBA — EXPEDIENTES DE EVALUACIÓN
-- ============================================================

-- Expediente 1: Estudiante elegible con puntaje alto
INSERT INTO EVA_ExpedienteEvaluacion
    (id_solicitud, id_estudiante, id_convocatoria, id_estado, puntaje_academico, puntaje_socioeconomico, puntaje_vulnerabilidad, puntaje_meritos, posicion_ranking, es_prioridad_alta, evaluacion_completa, usuario_creacion)
VALUES
    (1001, '1-0234-0567', 1, 2, 85.50, 90.00, 95.00, 80.00, 1, 1, 1, 'sistema.becas');

-- Expediente 2: Estudiante con evaluación en proceso
INSERT INTO EVA_ExpedienteEvaluacion
    (id_solicitud, id_estudiante, id_convocatoria, id_estado, puntaje_academico, puntaje_socioeconomico, posicion_ranking, evaluacion_completa, usuario_creacion)
VALUES
    (1002, '1-0345-0678', 1, 1, 78.00, 75.50, NULL, 0, 'sistema.becas');

-- Expediente 3: Estudiante con evaluación completa, puntaje medio
INSERT INTO EVA_ExpedienteEvaluacion
    (id_solicitud, id_estudiante, id_convocatoria, id_estado, puntaje_academico, puntaje_socioeconomico, puntaje_vulnerabilidad, puntaje_meritos, posicion_ranking, evaluacion_completa, usuario_creacion)
VALUES
    (1003, '1-0456-0789', 1, 2, 72.00, 68.50, 65.00, 55.00, 2, 1, 'sistema.becas');
GO

-- ============================================================
-- 5. DATOS ACADÉMICOS (desde integración ERP)
-- ============================================================

INSERT INTO EVA_DatosAcademicos
    (id_expediente, promedio_general, cantidad_reprobaciones, avance_curricular_pct, creditos_matriculados, estado_academico, tiene_sancion_activa, carrera, facultad, sede)
VALUES
    (1, 85.50, 1, 62.00, 15, 'ACTIVO', 0, 'Ingeniería en Sistemas', 'Ciencias e Ingeniería', 'San José'),
    (2, 78.00, 2, 48.00, 12, 'ACTIVO', 0, 'Administración de Empresas', 'Ciencias Económicas', 'Heredia'),
    (3, 72.00, 3, 35.00,  9, 'ACTIVO', 0, 'Enfermería',                'Ciencias de la Salud',  'Alajuela');
GO

-- ============================================================
-- 6. FICHAS SOCIOECONÓMICAS
-- ============================================================

INSERT INTO EVA_FichaSocioeconomica
    (id_expediente, ingreso_familiar_total, numero_dependientes, id_tipo_vivienda, gastos_mensuales, id_situacion_laboral, id_nivel_vulnerabilidad, tiene_discapacidad, validado_visita, puntaje_calculado, trabajador_social, fecha_evaluacion, observaciones)
VALUES
    (1, 450000.00, 4, 3, 380000.00, 1, 1, 0, 1, 90.00, 'marta.rodriguez', '2026-04-10', 'Familia numerosa con ingreso por debajo del umbral. Visita confirma condiciones declaradas. Se recomienda prioridad alta.'),
    (2, 680000.00, 3, 2, 520000.00, 2, 2, 0, 0, 75.50, 'marta.rodriguez', '2026-04-11', 'Ingreso familiar moderado. Estudiante trabaja medio tiempo para apoyar gastos. Situación estable pero ajustada.'),
    (3, 720000.00, 3, 5, 600000.00, 5, 2, 0, 0, 68.50, 'carlos.vega',     '2026-04-12', 'Familia pensionada. Ingresos suficientes para gastos básicos pero sin margen para educación universitaria.');
GO

-- ============================================================
-- 7. ENTREVISTAS
-- ============================================================

INSERT INTO EVA_Entrevista
    (id_expediente, id_tipo_entrevista, fecha_hora_entrevista, evaluador_usuario, puntaje_asignado, id_resultado, observaciones)
VALUES
    -- Expediente 1: entrevista de trabajo social
    (1, 2, '2026-04-14 09:00:00', 'marta.rodriguez', 88.00, 1, 'Estudiante demuestra motivación clara y necesidad económica evidente. Excelente actitud durante la entrevista.'),
    -- Expediente 1: entrevista académica
    (1, 3, '2026-04-14 10:30:00', 'ana.jimenez',     82.00, 1, 'Estudiante con buen desempeño y metas académicas definidas. Destaca en actividades del programa.'),
    -- Expediente 2: entrevista de trabajo social
    (2, 2, '2026-04-15 09:00:00', 'marta.rodriguez', 76.00, 1, 'Situación económica moderada. Estudiante trabaja y estudia. Necesita apoyo para continuar estudios a tiempo completo.'),
    -- Expediente 3: entrevista de trabajo social
    (3, 2, '2026-04-15 11:00:00', 'carlos.vega',     65.00, 3, 'Condiciones familiares moderadas. Se recomienda beca parcial. Estudiante sin actividades extracurriculares relevantes.');
GO

-- ============================================================
-- 8. VISITAS DOMICILIARES
-- ============================================================

INSERT INTO EVA_VisitaDomiciliar
    (id_expediente, fecha_visita, trabajador_social, condiciones_hogar, datos_confirmados, discrepancias_encontradas)
VALUES
    (1, '2026-04-13', 'marta.rodriguez',
     'Hogar con 6 personas en vivienda alquilada de 3 habitaciones. Condiciones básicas. Sin electrodomésticos de lujo. Agua y electricidad activas.',
     1, NULL);
GO

-- ============================================================
-- 9. RANKING DE CANDIDATOS
-- ============================================================

INSERT INTO EVA_Ranking
    (id_convocatoria, id_expediente, posicion, puntaje_total, congelado, usuario_generacion)
VALUES
    (1, 1, 1, 88.43, 0, 'ana.jimenez'),   -- (90*0.40)+(85.5*0.35)+(95*0.15)+(80*0.10) = 36+29.925+14.25+8 = 88.175 aprox
    (1, 3, 2, 70.23, 0, 'ana.jimenez'),
    (1, 2, 3, 64.50, 0, 'ana.jimenez');
GO

-- ============================================================
-- 10. EJECUCIÓN DE REGLAS (trazabilidad)
-- ============================================================

INSERT INTO REG_EjecucionRegla
    (id_regla, id_solicitud, condicion_evaluada, valor_encontrado, resultado, estado_asignado, es_simulacion)
VALUES
    (1, 1001, 'promedio_general >= 70', '85.50', 'CUMPLE',    'ELEGIBLE',              0),
    (2, 1001, 'creditos_matriculados >= 9', '15',  'CUMPLE',  'ELEGIBLE',              0),
    (6, 1001, 'ingreso_familiar_total < 800000', '450000', 'CUMPLE', 'PRIORIDAD_ALTA', 0),
    (1, 1002, 'promedio_general >= 70', '78.00', 'CUMPLE',    'ELEGIBLE',              0),
    (2, 1002, 'creditos_matriculados >= 9', '12',  'CUMPLE',  'ELEGIBLE',              0),
    (1, 1003, 'promedio_general >= 70', '72.00', 'CUMPLE',    'ELEGIBLE',              0),
    (2, 1003, 'creditos_matriculados >= 9', '9',   'CUMPLE',  'ELEGIBLE',              0);
GO

-- ============================================================
-- 11. RESOLUCIÓN DEL COMITÉ
-- ============================================================

INSERT INTO COM_ResolucionComite
    (numero_resolucion, id_expediente, id_convocatoria, estado_resolucion, porcentaje_beneficio, firmada, fecha_firma, observaciones, usuario_creacion)
VALUES
    ('RES-2026-0001', 1, 1, 'APROBADA',     100.00, 1, '2026-05-05 14:00:00', 'Candidato con la mayor puntuación en el ranking. Se aprueba beca completa.',          'comite.becas'),
    ('RES-2026-0002', 3, 1, 'APROBADA',      75.00, 1, '2026-05-05 14:30:00', 'Candidato aprobado con beca parcial del 75% por situación moderada.',                  'comite.becas'),
    ('RES-2026-0003', 2, 1, 'LISTA_ESPERA',   NULL, 1, '2026-05-05 15:00:00', 'Candidato en lista de espera. Se activará si se libera cupo en la convocatoria.',      'comite.becas');
GO

-- Acta de sesión del comité
INSERT INTO COM_ActaSesion
    (id_convocatoria, fecha_sesion, participantes, acuerdos, usuario_generacion)
VALUES
    (1, '2026-05-05 13:00:00',
     'Dra. Patricia Mora (Presidenta), Lic. Roberto Chaves, M.Sc. Carmen Solís, Prof. Luis Pérez',
     'Se revisaron 3 expedientes de la Convocatoria 2026-01. Se aprobaron 2 becas completas y 1 parcial. Un candidato quedó en lista de espera. Presupuesto utilizado: 85% del disponible.',
     'ana.jimenez');
GO

-- ============================================================
-- 12. BITÁCORA DE AUDITORÍA — entradas de ejemplo
-- ============================================================

INSERT INTO AUD_BitacoraEvaluacion
    (tabla_afectada, id_registro, accion, campo_modificado, valor_anterior, valor_nuevo, justificacion, ip_cliente, usuario_sistema)
VALUES
    ('EVA_ExpedienteEvaluacion', 1, 'INSERT', NULL, NULL, 'Expediente creado', 'Generación inicial del expediente de evaluación', '192.168.1.10', 'sistema.becas'),
    ('EVA_FichaSocioeconomica',  1, 'INSERT', NULL, NULL, 'Ficha registrada',  'Registro de ficha socioeconómica por Trabajador Social', '192.168.1.22', 'marta.rodriguez'),
    ('EVA_Entrevista',           1, 'INSERT', NULL, NULL, 'Entrevista registrada', 'Registro de entrevista de trabajo social', '192.168.1.22', 'marta.rodriguez'),
    ('COM_ResolucionComite',     1, 'UPDATE', 'firmada', '0', '1', 'Firma de resolución por quórum del Comité alcanzado', '192.168.1.30', 'comite.becas'),
    ('EVA_Ranking',              1, 'UPDATE', 'congelado', '0', '1', 'Congelamiento del ranking al iniciar sesión del Comité', '192.168.1.30', 'ana.jimenez');
GO

-- Log de integraciones
INSERT INTO AUD_LogIntegracion
    (servicio_externo, id_estudiante, endpoint_consultado, respuesta_recibida, codigo_respuesta, exitoso, tiempo_respuesta_ms)
VALUES
    ('ERP_ACADEMICO', '1-0234-0567', '/api/academico/estudiante/1-0234-0567/datos', '{"promedio":85.5,"creditos":15,"avance":62.0,"estado":"ACTIVO"}', '200', 1, 312),
    ('ERP_ACADEMICO', '1-0345-0678', '/api/academico/estudiante/1-0345-0678/datos', '{"promedio":78.0,"creditos":12,"avance":48.0,"estado":"ACTIVO"}', '200', 1, 287),
    ('ERP_ACADEMICO', '1-0456-0789', '/api/academico/estudiante/1-0456-0789/datos', '{"promedio":72.0,"creditos":9, "avance":35.0,"estado":"ACTIVO"}', '200', 1, 305);
GO

PRINT 'Datos de prueba insertados exitosamente.';
GO

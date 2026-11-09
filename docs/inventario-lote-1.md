# Inventario Lote 1 — Carpeta DRIVE_ALL_TECSO_ROBERT (Google Drive)

Fecha de inventario: 9 de noviembre de 2026. Alcance: solo lectura y clasificación propuesta con el criterio perceptivo. Nada se movió, renombró ni descartó. Adrián aprueba o corrige cada renglón; sus correcciones ajustan el criterio.

Resumen de volumen: la carpeta raíz contiene tres carpetas. **DATA_WAREHOUSE_TECSO** concentra 608 archivos (590 en PROJECTS y 18 en INTERN_DATA). **Roberto** es una bóveda de notas de trabajo (Obsidian) con notas diarias del 1 de octubre al 6 de noviembre de 2026 y piezas sueltas de proyecto. **UVM** contiene 2 archivos universitarios.

## 1. INTERN_DATA — núcleo legal, fiscal y contractual

| Grupo | Contenido | Estado propuesto | Destino | Confianza |
|---|---|---|---|---|
| ACTA_CONSTITUTIVA_TECSO | Acta constitutiva 2006 (escritura 81,828), nombramiento de administrador único, escrituras y poderes | Producto final (documento legal vigente) | Área Contratos / expediente legal de la firma, acceso restringido | Alta |
| CONSTANCIA_FISCAL | Constancia fiscal (agosto 2026) | Producto final vigente | Expediente legal-fiscal | Alta |
| ESTADOS_FINANCIEROS | Estado de resultados general, estados de situación financiera, conciliación contable fiscal | Producto final (cierre contable) | Área Finanzas, acceso restringido | Alta |
| CONTRATOS / Huimanguillo y San Pedro Garza | Contrato CPS-308-2026, contrato TECSO con fecha 11-06-2026 en el nombre, orden de contratación SC-1315 | Producto final (instrumentos firmados) | Área Contratos, ligado a su proyecto | Alta |
| CRV_DOCUMENTACION | Documentos de la camioneta CRV: INE del propietario, factura, póliza BBVA, acta de denuncia de robo, requerimientos | Administrativo-vehicular; contiene datos personales | Expediente administrativo restringido; el warehouse solo registra su existencia, no su contenido | Alta |

## 2. PROJECTS / Huimanguillo — el proyecto mayor (≈500 archivos)

| Grupo | Señales observadas | Estado propuesto | Destino | Confianza |
|---|---|---|---|---|
| Estructura RAW_DATA / PROCESS_DATA / REPORT_INSIGHTS_DATA | El proyecto ya se organiza por capas, como el warehouse | Estructura adoptable | La taxonomía del proyecto se conserva como referencia de diseño | Alta |
| Familia «Resumen_Reporte_Lineas_de_Accion» (≈30 archivos, 27 oct–06 nov, versiones V1–V6 por día, variantes «TRABAJADA», «VFCMANDADO», «copia») | Cadena de versiones densísima en días consecutivos | La más reciente de cada corte = producto en curso; el resto = borradores superados | Al cierre, solo la versión entregada pasa a producto final; las demás quedan como referencia del proyecto | Alta |
| Formatos de captación por dirección (≈20 xlsx: Jurídico, DECUR, DAM, Protección Ambiental, Programación, Vigilancia de Tránsito, Atención Ciudadana…) | Son los Formatos B llenados por cada área; hay duplicados exactos por nombre y tamaño | Insumo (captura recibida del cliente) | Capa cruda del proyecto, deduplicando por contenido | Alta (dedupe por confirmar tras comparar contenido) |
| Family «Analisis / Resumen / Cuadros Eje II» (docx/pptx en versiones v1–v4) | Trabajo analítico iterativo con versiones | Producto en curso (versión mayor) + borradores superados | Área de trabajo del proyecto; al cierre se promueve la entregada | Alta |
| EvSoc Hidrocarburos, Central Camionera, Evaluación K0120080055 | Documentos de evaluación con nombre de producto | Producto en curso / final por confirmar | Entregables del proyecto | Por confirmar: falta constancia de entrega |
| Informe de Gobierno Huimanguillo 2025 (PDF, 213 MB) y autoevaluación presupuestal 4T-2025 (xlsx) | Documentos oficiales del cliente que alimentan el cruce | Insumo fuente | Capa cruda como fuente oficial citada | Alta |
| Sistema PMD (index.html, config.js, supabase-schema.sql, entregas en zip, index_vijeo.html) | Es la copia de trabajo del sistema que vive en el repositorio GitHub | Referencia técnica; la fuente vigente es el repositorio | Biblioteca técnica; los zip de entrega = borradores superados del sistema | Alta |
| Paquete de licitación de obras, oficios, transcripciones de Zoom, taller 29 oct | Soporte documental del proyecto | Insumo / material de proceso | Expediente del proyecto | Alta |

## 3. PROJECTS / San Pedro Garza

| Grupo | Señales | Estado propuesto | Destino | Confianza |
|---|---|---|---|---|
| Informe Dx PbR-SED 2026 (PDF) + Anexos 1–4 y zip del diagnóstico (41 MB) | Paquete de diagnóstico con anexos, estructura de entregable | Producto final por confirmar | Entregables y banco de experiencia | Por confirmar: constancia de entrega |
| Carpetas RAW_DATA / PROCESS_DATA / REPORT_INSIGHTS_DATA (con un Z_NO_CLASIFICADO) | Misma organización por capas; existe una carpeta de no clasificados | Estructura + rezago de clasificación | La carpeta Z_NO_CLASIFICADO es el primer candidato a pasar por el criterio | Alta |

## 4. PROJECTS / Seguritec y Z_SED_PbR_2026_MUNICIPIOS_A

| Grupo | Señales | Estado propuesto | Destino | Confianza |
|---|---|---|---|---|
| Seguritec: matrices de riesgos y controles (v2, Deloitte 2020), análisis de riesgos y actividades de control (PDF) | Material metodológico de control interno, mezcla de producción propia y referencia externa | Metodología y referencia | Biblioteca de conocimiento (la v2 propia) y referencias (Deloitte) | Media |
| Z_SED_PbR_2026_MUNICIPIOS_A | Carpeta de diagnóstico SED/PbR 2026 por municipios | Proyecto en curso | Se detalla cuando Adrián confirme su alcance | Por confirmar |

## 5. Carpeta «Roberto» — bóveda personal de trabajo (Obsidian)

| Grupo | Señales | Estado propuesto | Destino | Confianza |
|---|---|---|---|---|
| Notas diarias 1 oct – 6 nov 2026 (≈20 archivos md) | Bitácora diaria de su reincorporación; dos notas de 50–69 KB (05 y 06 nov) concentran lo sustantivo | Material de proceso (bitácora operativa personal) | Se lee agregado para extraer flujo, estructura y vocabulario; no entra como producto | Alta |
| PMD MANUAL HUIMANGUILLO.md (28 KB) | Manual operativo del proyecto | Metodología viva | Biblioteca de conocimiento, candidato a plantilla del molde | Alta |
| Vinculacion_Indicadores_PMD_2024_2027_final_V07.xlsx | Nombre con «final» y versión mayor V07 | Producto final por confirmar | Indicadores y PMD, capa núcleo tras validar contenido | Por confirmar: validar que su contenido está cerrado |
| EJE 2 Piloto prueba resumen, PROYECTO Automatización de Evaluación PMD | Notas de diseño de su automatización previa | Referencia de diseño | Biblioteca técnica del warehouse | Alta |
| Notas «Sin título» (5, dos en 0 B y una de 155 KB) y notas vacías | Mezcla: vacías = ruido; la de 155 KB requiere lectura para clasificar | Ruido (0 B) / por confirmar (155 KB) | Descarte de vacías con aprobación; lectura de la grande | Alta / por confirmar |
| .obsidian y SKILLS | Configuración de su herramienta y habilidades personales | Fuera de alcance operativo | No entra al warehouse | Alta |

## 6. Carpeta UVM (2 archivos)

Libro de ciencia de datos (35 MB) y una actividad académica. **Fuera de alcance**: es material universitario de Adrián, no de TECSO. No entra al warehouse ni se clasifica en detalle.

## Observaciones de diseño que deja este lote

1. Huimanguillo y San Pedro ya usan capas RAW / PROCESS / REPORT: el warehouse formaliza una práctica que Adrián ya inició; el molde la vuelve sistema.
2. La proliferación de versiones es el síntoma principal del desorden: familias de 30 archivos para un solo reporte semanal. La regla «una versión vigente identificable por producto» es la primera norma que el warehouse impone.
3. Existe ya una carpeta Z_NO_CLASIFICADO: el rezago de clasificación es real y el criterio perceptivo tiene su primer caso de aplicación.
4. Los contratos de INTERN_DATA (CPS-308-2026 y el contrato fechado 11-06-2026) pueden ayudar a contrastar datos de contratación recientes que la investigación web dejó sin confirmar; se revisarán con Adrián en la tabla de correcciones.

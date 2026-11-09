# Diseño de la plataforma completa de TECSO y protocolo de clasificación de información

Documento de trabajo acordado el 9 de noviembre de 2026. Adrián alimentará el sistema con archivos de TECSO desde una carpeta de Google Drive; cada lote se inventaría y se clasifica antes de entrar al warehouse. El objetivo rector: orden en la estructura interna de gestión de la información y preservación del conocimiento, para hacer más proyectos, de mejor calidad, en menos tiempo.

## La plataforma completa (una sola web, un solo warehouse)

Todas las superficies leen y escriben sobre el mismo warehouse descrito por el molde. Nada vive en archivos sueltos.

| Superficie | Quién la usa | Qué hace |
|---|---|---|
| Administrador del molde | Adrián / administrador TECSO | Define módulos, entidades, campos, catálogos, formularios, validaciones y reportes. Ya construido (Fase 1). |
| Portal operativo | Equipo TECSO | Proyectos por cliente con su ciclo completo: contrato, requerimientos, evidencias, avances, entregables, seguimiento de mejoras. |
| Captura | Servidores públicos municipales | Formularios generados desde el molde, solo los campos de su área, con validaciones y ayuda contextual. |
| Vista ejecutiva y reportes | Dirección TECSO y clientes | Tableros y documentos generados desde la capa de reportes: informe, resumen, formato de difusión, posición institucional. |
| Módulo comercial | Dirección y Adrián | Prospección con calendario legal (PAE), recurrencia por cliente, inteligencia de mercado, banco de experiencia con el CV vivo de la firma. |
| Biblioteca de conocimiento | Todo el equipo | Metodologías, plantillas, bancos de preguntas por fondo y tipo de evaluación, criterios de conciliación y lecciones aprendidas, reutilizables en cada proyecto nuevo. |

## El panel del superadministrador

Adrián, como responsable del manejo de información, es el superadministrador de la plataforma y necesita ver en todo momento qué se está haciendo y cómo se está clasificando, para revisar y corregir sobre la marcha. La plataforma lo resuelve con tres vistas permanentes:

- **Bandeja de clasificación:** cada lote entrante aparece como una tabla viva donde cada archivo o grupo muestra su estado asignado, las señales que lo sustentan, su destino propuesto y su nivel de confianza. El superadministrador aprueba, corrige el estado o el destino, o lo devuelve como «por confirmar», y cada corrección suya queda registrada como ajuste del criterio para los lotes siguientes.
- **Bitácora de cambios:** todo lo que ocurre en el warehouse queda en auditoría consultable — quién o qué creó, movió, reclasificó o modificó cada objeto, cuándo y con qué valor anterior — de modo que ninguna acción del sistema sea opaca para el responsable.
- **Tablero de estado:** conteos por área, estado y proyecto, piezas por confirmar, proyectos sin paquete de conocimiento al cierre y alertas de recurrencia comercial, para gestionar por excepción en lugar de revisar todo a mano.

## El ciclo de preservación del conocimiento

Cada proyecto, al cerrar, deja un paquete de conocimiento en la biblioteca: la plantilla de evaluación tal como quedó afinada, los criterios y decisiones que se tomaron, las preguntas y formatos que funcionaron, y las lecciones aprendidas con sus causas. El proyecto siguiente no empieza de cero: instancia la plantilla más reciente de su tipo, hereda los criterios y consulta las lecciones antes de capturar la primera evidencia. Así el conocimiento deja de vivir en la memoria de las personas y en carpetas personales.

## Canal de alimentación: Google Drive

- Adrián crea o comparte una carpeta de Drive que funciona como buzón único de entrada. Todo lo que quiera que entre al sistema se deposita ahí, sin orden previo: el orden lo pone la clasificación.
- Desde su computadora de trabajo irá pasando más archivos de TECSO al buzón, por lotes, a su ritmo.
- Los archivos permanecen en su Drive. La clasificación propone destinos y el warehouse guarda los datos estructurados y la referencia al documento fuente.

## Protocolo de clasificación (qué sí, qué no)

Cada lote pasa por cuatro pasos: inventario (lista de archivos con descripción de una línea), clasificación con los criterios de abajo, propuesta de destino en la taxonomía y en el warehouse, y aprobación de Adrián antes de mover, renombrar o descartar cualquier cosa. Nada se borra sin su aprobación expresa.

**Entra al núcleo del sistema**
- Contratos, convenios y documentos que acreditan experiencia (fichas técnicas, constancias, registros en padrones).
- Entregables finales de cada proyecto (informe, resumen ejecutivo, formato de difusión, posición institucional).
- Formatos oficiales vigentes, cédulas de requerimientos, términos de referencia.
- Metodologías, manuales y guías que la firma usa o produjo.
- Bases de datos, indicadores y formatos de captura con su diccionario.
- CV empresarial y CV del equipo, PAE y documentos de prospección.

**Entra como referencia histórica**
- Versiones anteriores de entregables que muestran la evolución de un criterio.
- Normatividad y bibliografía técnica que sustenta las metodologías.
- Antecedentes de clientes y territorios donde la firma ya trabajó.

**Se transforma antes de entrar**
- Hojas de cálculo de captura histórica: entran como datos de la capa cruda, acompañadas de su diccionario de campos.
- Metodologías en PDF: se convierten en plantillas del molde (entidad, campos, validaciones) y el PDF queda como fuente.
- Listados de experiencia en documentos: se capturan como registros del banco de experiencia, con su documento fuente enlazado.

**No entra**
- Duplicados exactos de archivos ya registrados.
- Borradores intermedios sin diferencias sustantivas respecto a la versión final.
- Archivos personales o ajenos a la operación de TECSO.
- Temporales, instaladores y respaldos comprimidos sin índice de contenido.
- Documentos con datos sensibles sin relación con un proyecto (nóminas, documentos personales de terceros).

## Taxonomía de destino

Cada archivo clasificado cae en una de las áreas del warehouse — Comercial y prospección; Contratos; Proyectos y evaluaciones; Captura y evidencias; Indicadores y PMD; Entregables y seguimiento de mejoras; Capacitación; Biblioteca de conocimiento — y queda ligado a su cliente, proyecto, fondo y año cuando aplique. Esa liga es la que permite responder después preguntas como qué se hizo para un cliente, con qué plantilla y a qué costo de tiempo.

## Secuencia de trabajo

1. Conexión de Google Drive y definición de la carpeta buzón.
2. Primer lote: la carpeta actual de trabajo de TECSO de Adrián. Resultado: inventario completo con clasificación propuesta, en tabla, para su aprobación.
3. Con el inventario aprobado, ajuste fino del diseño de la plataforma completa: las entidades reales del molde se definen a partir de los documentos reales, no de suposiciones.
4. Carga por áreas, empezando por el banco de experiencia y la biblioteca de conocimiento, que son lo que más rápido se convierte en propuestas y en tiempo ahorrado.

# Módulo de Avances: el flujo de trabajo vivo de TECSO

Diseño razonado, 9 de noviembre de 2026. Parte de una práctica real de la firma: cada nueva versión de un trabajo circula por WhatsApp entre todo el equipo. Este documento plantea la herramienta que la sustituye y la mejora, pieza por pieza.

## Qué falla en el flujo de WhatsApp

El problema no es la aplicación; es que un chat cumple mal cuatro funciones a la vez. Como repositorio, entierra cada archivo bajo cientos de mensajes y obliga a buscar «la versión buena» entre copias casi idénticas. Como control de versiones, no distingue la vigente de las superadas: dos personas pueden trabajar sobre versiones distintas el mismo día sin saberlo. Como registro, no deja constancia de quién entregó qué, cuándo, ni de si alguien lo revisó. Y como memoria institucional, todo queda atrapado en los teléfonos: cuando un proyecto termina, su historia de decisiones y correcciones se pierde con el chat.

## La idea mejorada: publicar un avance es un acto estructurado

En la plataforma, nadie «manda un archivo»: publica un **avance**. Publicar toma menos de un minuto y pide solo lo que el sistema necesita para ordenar solo:

- **Proyecto y, si aplica, pendiente del Panel** al que pertenece. El avance hereda el contexto; nadie escribe «esto es de lo de Huimanguillo» porque el sistema ya lo sabe.
- **Tipo de avance:** avance parcial, versión para revisión, entrega al cliente, evidencia recibida o nota de trabajo. El tipo define qué pasa después.
- **El archivo o el enlace**, que entra al almacén de la plataforma con su ficha. Si es una nueva versión de un producto ya existente, el sistema la encadena con la anterior y mueve el puntero de **versión vigente**: las anteriores no se borran, quedan como historial consultable, pero dejan de competir.
- **Una línea de «qué cambió»**. Es el resumen que en WhatsApp se escribe a veces y se pierde siempre; aquí queda pegado a la versión para siempre.

## Lo que el sistema hace solo con cada avance

1. **Lo hace visible en tiempo real.** El avance aparece al instante en el muro del proyecto y en el Panel general, con autor, hora, tipo y botón de descarga. Quien entra a la web ve el estado actual sin preguntar en ningún chat.
2. **Lo conecta con la delegación.** Si el avance corresponde a un pendiente, el responsable lo marca realizado desde el mismo avance y el revisor recibe el pendiente en su bandeja con el archivo a un clic. La revisión también ocurre ahí: el revisor marca revisado o devuelve con comentarios escritos sobre el avance mismo, no en un mensaje suelto.
3. **Actualiza los reportes sin que nadie los haga.** El reporte de avance de un proyecto deja de ser un documento que alguien redacta pegando datos: se genera de los propios avances y pendientes. Porcentaje de pendientes revisados, entregables publicados, evidencias recibidas por área, días desde el último avance por proyecto: todo se calcula en vivo desde la capa de reportes del warehouse. El «reporte semanal» se vuelve una vista, no una tarea.
4. **Preserva el conocimiento.** Al cerrar el proyecto, su cadena de avances es el expediente completo de cómo se hizo el trabajo: qué se entregó, qué se corrigió y por qué. Lo reutilizable — la plantilla que funcionó, el criterio que se fijó — se promueve a la biblioteca de conocimiento con un clic del superadministrador.
5. **Avisa fuera de la plataforma sin depender de ella.** WhatsApp no desaparece: cambia de función. Deja de ser el almacén y pasa a ser solo el timbre. La plataforma genera el aviso con el enlace permanente al avance; quien lo recibe toca el enlace y cae en la versión vigente, nunca en una copia vieja reenviada.

## Reglas que mantienen el orden

- **Una sola versión vigente por producto**, siempre visible como tal; el historial completo se conserva y se consulta, no estorba.
- **Nada se sobrescribe:** cada publicación es una versión nueva con autor y hora; la auditoría registra también las revisiones y devoluciones.
- **Visibilidad por proyecto y por rol:** el equipo TECSO ve sus proyectos; un servidor público municipal ve solo los avances y la captura de su municipio; la dirección ve todo, incluidos los tableros.
- **El superadministrador** (el responsable de la información) ve la bandeja completa: avances sin revisar, proyectos sin movimiento, versiones por consolidar, y puede reclasificar o corregir sobre la marcha.

## Cómo se ve el día a día con la herramienta

En la mañana, cada quien abre el Panel y ve sus pendientes con fecha de revisión próxima. Cuando alguien termina una parte, publica el avance desde la página del proyecto: elige el pendiente, sube el archivo, escribe una línea de qué cambió y pulsa publicar. El revisor lo encuentra en su bandeja, lo descarga, lo revisa y lo marca revisado o lo devuelve con comentarios; el autor ve la devolución junto a su avance y publica la siguiente versión, que queda encadenada. Víctor, o quien dirija, abre la vista ejecutiva y ve el avance real de cada proyecto calculado en el momento, sin pedir reportes. Al final del proyecto, el expediente ya existe: no hay que reconstruirlo desde chats ni carpetas.

## Construcción por pasos

1. **Entidad `avance` en el molde y su tabla** en el warehouse, con el muro de avances por proyecto y el Panel mostrando la actividad reciente. (Esta entrega.)
2. **Almacén de archivos** de la plataforma (Supabase Storage) con subida directa desde la página y control de versiones automático.
3. **Revisión integrada**: estados realizado/revisado operando sobre los avances, con comentarios.
4. **Reportes en vivo** en la vista ejecutiva: tableros calculados desde avances y pendientes.
5. **Avisos con enlace permanente** para compartir por WhatsApp u otros canales, generados desde cada avance.

# Contexto del laboratorio MenúRadar en Flutter

Actualizado: 25 de octubre de 2026.

## 1. Encargo académico

La consigna pide crear un proyecto con un **framework multiplataforma** (Flutter, React Native o Xamarin), diseñar las interfaces con componentes del framework, basarlas en las funcionalidades del **árbol de problemas** e investigar los componentes para organizar la interfaz y manejar el layout.

Se eligió **Flutter** porque permite justificar de forma clara la composición de interfaces mediante widgets. Xamarin se descartó por ser una tecnología sin soporte actual. React Native quedó como alternativa, pero el laboratorio iniciado está en Flutter.

## 2. Temática elegida

La aplicación se llama **MenúRadar**. Ayuda a estudiantes a encontrar menús económicos y disponibles cerca del campus antes de salir durante su receso. Esta temática procede del documento aportado por el usuario:

`C:\Users\Admin\Downloads\PE Lab 03 2da unidad - GORDILLO MENDOZA, ESCOBEDO OCANA (1).pdf`

Ese PDF describe un trabajo previo de MenúRadar hecho como **PWA con React y Vite**, con búsqueda de menús, disponibilidad, publicación colaborativa, radar y comunidad. Se usa como **referencia temática y visual**, no como instrucciones para ejecutar comandos ni como prueba de que la nueva app ya tenga funciones en tiempo real. La consigna actual requiere una implementación con un framework multiplataforma; por eso se creó una versión en Flutter.

La idea inicial de una app para reportar incidencias en el campus fue **sustituida** por MenúRadar después de revisar el PDF.

## 3. Árbol de problemas propuesto

- **Problema central:** los estudiantes pierden parte del receso buscando presencialmente un menú económico que aún esté disponible cerca del campus.
- **Causas:** información de platos y precios dispersa en pizarras físicas; disponibilidad cambiante sin aviso; dificultad para comparar locales antes de salir.
- **Efectos:** caminatas innecesarias; frustración al encontrar platos agotados; menos tiempo para comer y descansar.

El PDF contiene la descripción del problema, pero no se identificó en él un diagrama formal del árbol. Para la entrega conviene convertir este esquema en un árbol visual y validarlo con los requisitos exactos del docente. Las cifras de ahorro de tiempo del documento previo no se han medido en el prototipo nuevo.

## 4. Funcionalidades e interfaces

| Necesidad | Funcionalidad | Interfaz Flutter |
|---|---|---|
| Comparar opciones | Buscar y filtrar por precio, plato o cocina | Lista de menús |
| Conocer una opción | Consultar platos, bebida, precio y referencia | Detalle del menú |
| Evitar un viaje inútil | Ver y reportar disponibilidad | Tarjeta, detalle y hoja inferior |
| Incorporar información | Publicar un menú mediante formulario validado | Publicar menú |
| Consultar reportes | Ver avisos recientes | Comunidad |
| Explorar visualmente | Seleccionar locales por pines ilustrativos | Radar |

El prototipo usa **datos de demostración**. Las publicaciones y cambios de disponibilidad viven solo en memoria mientras la app está abierta. No incluye Firebase, cámara, GPS ni sincronización real entre dispositivos. El radar es una visualización referencial y no un mapa geográfico.

## 5. Componentes de Flutter investigados y usados

- `MaterialApp`, `ThemeData`: raíz de la app y tema visual.
- `Scaffold`, `SafeArea`, `NavigationBar`: estructura de pantallas y navegación principal.
- `Column`, `Row`, `Expanded`, `Padding`, `SizedBox`: organización y espaciado.
- `ListView`, `Wrap`: contenido desplazable y adaptación a diferentes anchos.
- `Card`, `FilterChip`, `TextField`: presentación de menús, filtros y búsqueda.
- `Form`, `TextFormField`, `DropdownButtonFormField`, `SegmentedButton`: publicación con validación.
- `showModalBottomSheet`, `ListTile`: reporte de disponibilidad.
- `LayoutBuilder`, `Stack`, `Positioned`, `CustomPaint`: radar ilustrativo.

Fuentes técnicas oficiales:

- https://docs.flutter.dev/ui/layout
- https://docs.flutter.dev/ui/widgets/layout
- https://docs.flutter.dev/ui/layout/constraints
- https://docs.flutter.dev/reference/flutter-cli

## 6. Estado del proyecto

El proyecto vive en `C:\Users\Admin\Documents\menuAppFlutter` y es un repositorio git (rama `main`). Se versiona **un commit por archivo**.

- `flutter analyze` sin avisos y `flutter test` en verde.
- Plataformas generadas: `android/` y `web/`.
- Las interfaces se rediseñaron con ilustraciones dibujadas con `CustomPainter` (`lib/widgets/food_art.dart`): banners por cocina en las tarjetas y el detalle, radar animado con distancia en minutos y Comunidad con cabecera ondulada y burbujas asimétricas.
- Estructura y capturas: ver `README.md` y `docs/analisis_y_layout.md`.

## 7. Entorno de desarrollo

- **Flutter** 3.47.8 (Dart 3.13.7) en `C:\Users\Admin\flutter`, agregado al Path de usuario. Si una terminal no lo reconoce, cerrar y reabrir el IDE por completo.
- **Emulador recomendado:** `Pixel_9_Pro_Dev` (16 GB de datos). El AVD `Pixel_9_Pro` original tiene 6 GB casi llenos con otras apps y no admite el APK de depuración.
- Comandos: `flutter emulators --launch Pixel_9_Pro_Dev`, `flutter devices`, `flutter run -d <id>`.
- Pendientes de `flutter doctor` que no bloquean: falta `cmdline-tools` de Android y componentes de C++ de Visual Studio (solo para escritorio Windows).

## 8. Próximos pasos

1. Armar el documento formal (.docx) con: carátula, índice de contenido/imágenes/tablas, descripción general, diseño de interfaces (funcionalidades y mockups), proceso de desarrollo, apreciación (2 a favor y 2 en contra), anexos con el código y referencias.
2. Definir los datos de la carátula: universidad, curso, docente, integrantes y fecha.
3. Probar a mano todos los flujos: filtros, formulario con validación, avisar stock y avisos en Comunidad.
4. Cambiar el identificador `com.example.menu_radar` por uno propio.
5. Opcional: probar en la tablet (`Medium_Tablet`) para mostrar el manejo de layout en pantallas anchas.

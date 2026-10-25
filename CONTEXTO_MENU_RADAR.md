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

## 6. Estado de los archivos

El código fuente y la documentación del laboratorio están en:

`C:\Users\Admin\Documents\Codex\2026-10-25\empleando-un-framework-multiplataforma-flutter-react\outputs\laboratorio_menu_radar`

Archivos principales:

- `pubspec.yaml`: configuración del paquete Flutter.
- `lib/main.dart`: arranque.
- `lib/models/menu.dart`: modelos y estados de disponibilidad.
- `lib/data/menu_store.dart`: datos de muestra y estado temporal.
- `lib/screens/home_shell.dart`: lista de menús, radar y comunidad.
- `lib/screens/menu_detail_page.dart`: detalle.
- `lib/screens/publish_menu_page.dart`: formulario.
- `lib/widgets/`: tarjeta, indicador de estado y hoja inferior.
- `docs/analisis_y_layout.md`: explicación de árbol de problemas, pantallas y widgets.
- `README.md`: alcance, estructura y comandos.

Se verificó la existencia de los archivos y que los imports relativos apuntan a archivos presentes. **No se pudo ejecutar `flutter analyze` ni la app** porque Flutter y Dart no estaban instalados en el entorno al momento de preparar el proyecto. Tampoco se generaron aún las carpetas de plataforma `android/`, `web/` o `ios/`.

## 7. Instalación y ejecución desde terminal en Windows

El usuario prefiere usar PowerShell y **no necesita VS Code**. En el equipo se detectaron Git, VS Code, Android Studio y el Android SDK; Flutter no aparecía instalado. Una instalación posible por terminal es:

```powershell
$sdkParent = Join-Path $env:USERPROFILE 'develop'
New-Item -ItemType Directory -Force -Path $sdkParent
git clone --branch stable https://github.com/flutter/flutter.git (Join-Path $sdkParent 'flutter')

$flutterBin = Join-Path $sdkParent 'flutter\bin'
$env:Path = "$flutterBin;$env:Path"
flutter --version
flutter doctor -v
```

Para guardar el `Path` en la cuenta de Windows:

```powershell
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (($userPath -split ';') -notcontains $flutterBin) {
    [Environment]::SetEnvironmentVariable('Path', "$flutterBin;$userPath", 'User')
}
```

Después, cerrar y abrir PowerShell. Si `flutter doctor` indica licencias Android pendientes, ejecutar `flutter doctor --android-licenses` y revisar cada licencia. Para generar plataformas y probar el laboratorio:

```powershell
Set-Location -LiteralPath 'C:\Users\Admin\Documents\Codex\2026-10-25\empleando-un-framework-multiplataforma-flutter-react\outputs\laboratorio_menu_radar'
flutter create --project-name menu_radar --platforms=android,web .
flutter pub get
flutter analyze
flutter run -d chrome
```

Para Android, iniciar un emulador desde Android Studio o conectar un teléfono con depuración USB; luego usar `flutter devices` y `flutter run`. Para compilar iOS se requiere macOS.

## 8. Próximos pasos

1. Instalar Flutter o confirmar si ya se instaló; ejecutar `flutter doctor -v`.
2. Generar archivos de plataforma con `flutter create --project-name menu_radar --platforms=android,web .` dentro de la carpeta del laboratorio.
3. Ejecutar `flutter analyze`; corregir cualquier diagnóstico de la versión de Flutter instalada.
4. Abrir y probar la app en Chrome y en Android. Verificar filtros, detalle, formulario, reporte de disponibilidad y comunidad.
5. Revisar visualmente las pantallas en un tamaño móvil y ajustar desbordes o espacios si aparecen.
6. Preparar el árbol de problemas formal y las capturas para la entrega académica.

## 9. Nota sobre la nueva carpeta

Este archivo conserva el contexto. La carpeta `C:\Users\Admin\Documents\menuAppFlutter` se pidió como ubicación separada para continuar el trabajo. El código del prototipo sigue en la ruta indicada en la sección 6 hasta que el usuario decida copiarlo o moverlo.

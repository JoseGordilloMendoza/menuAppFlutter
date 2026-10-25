# Laboratorio: MenúRadar en Flutter

Prototipo móvil multiplataforma para consultar menús económicos cerca del campus, comparar precios y avisar si quedan raciones. La temática procede del trabajo previo **MenúRadar**; esta entrega se concentra en interfaces construidas con widgets de Flutter y en el análisis del layout.

## Alcance implementado

- **Menús:** búsqueda por local o plato, filtros por precio y tipo de cocina, tarjetas con precio, distancia y disponibilidad.
- **Detalle:** entradas, platos, bebida y estado del menú.
- **Radar:** vista visual referencial construida con `Stack`, `LayoutBuilder` y `CustomPaint`; al tocar un pin abre el detalle.
- **Comunidad:** avisos ordenados cronológicamente.
- **Publicar:** formulario validado para añadir un menú a la sesión.
- **Avisar stock:** hoja inferior para actualizar el estado y generar un aviso comunitario.

Los restaurantes y avisos iniciales son **datos de demostración**. Las publicaciones y cambios se mantienen en memoria durante la sesión; no hay sincronización entre dispositivos, cámara ni GPS real. El radar muestra posiciones ilustrativas y no debe interpretarse como un mapa geográfico.

## Ejecutar

Se requiere el SDK de Flutter y un emulador o dispositivo configurado. En la carpeta de este laboratorio:

```powershell
flutter create --project-name menu_radar --platforms=android,web .
flutter pub get
flutter run
```

Para generar la plataforma iOS, ejecutar en macOS:

```bash
flutter create --project-name menu_radar --platforms=ios .
flutter run
```

El código fuente ya está en `lib/`. `flutter create` genera los archivos de plataforma que requiere cada equipo. El proyecto no usa paquetes externos en tiempo de ejecución.

Si todavía no hay un emulador o teléfono Android conectado, se puede comprobar primero en Chrome con `flutter run -d chrome`.

## Organización

```text
lib/
  main.dart                     Tema y arranque
  models/menu.dart              Datos y estados
  data/menu_store.dart          Estado temporal del prototipo
  screens/home_shell.dart       Menús, radar y comunidad
  screens/menu_detail_page.dart Detalle
  screens/publish_menu_page.dart Formulario
  widgets/                    Tarjeta, estado y hoja inferior
docs/analisis_y_layout.md      Árbol de problemas y componentes Flutter
```

## Validación pendiente en un equipo con Flutter

```powershell
flutter analyze
flutter run
```

El SDK de Flutter no está instalado en el entorno donde se preparó esta carpeta; por ello no se ejecutaron esas comprobaciones aquí.

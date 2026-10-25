# MenúRadar · Laboratorio de Flutter

Prototipo móvil multiplataforma para encontrar menús económicos y disponibles cerca del campus antes de salir al receso. Las interfaces están construidas solo con widgets de Flutter y sin paquetes externos, con énfasis en **Android**.

| Menús | Radar | Comunidad |
|:---:|:---:|:---:|
| ![Menús](docs/capturas/01_lista.png) | ![Radar](docs/capturas/02b_radar_seleccion.png) | ![Comunidad](docs/capturas/03_comunidad.png) |

| Detalle | Publicar |
|:---:|:---:|
| ![Detalle](docs/capturas/04_detalle.png) | ![Publicar](docs/capturas/05b_publicar_vista_previa.png) |

## Qué incluye

| Pantalla | Qué resuelve |
|---|---|
| **Menús** | Buscar y filtrar por precio o cocina; cada tarjeta muestra precio, estado y platos de un vistazo. |
| **Detalle** | Entrada, plato de fondo y bebida, con minutos a pie y referencia del local. |
| **Radar** | Cada local aparece a una distancia proporcional a sus minutos a pie; al tocar un pin se ve una vista previa. |
| **Comunidad** | Avisos recientes de otros estudiantes. Se publica sin cuenta: la primera vez se elige un apodo. |
| **Publicar** | Formulario con íconos, tres secciones y vista previa en vivo del menú. |
| **Avisar stock** | Hoja inferior para actualizar el estado de un menú. |

> **Datos de demostración.** Los locales y avisos son de ejemplo. Los cambios viven en memoria mientras la app está abierta: no hay base de datos, GPS, cámara ni sincronización entre dispositivos. El radar es una visualización referencial, no un mapa.

## Ejecutar

Requisitos: Flutter 3.47 o superior y un emulador Android (o Chrome para una prueba rápida).

```powershell
flutter pub get
flutter emulators --launch Pixel_9_Pro_Dev   # o el emulador que tengas
flutter run
```

- `flutter run -d chrome` abre la app en el navegador, sin emulador.
- Durante `flutter run`, `r` recarga el código y `R` reinicia la app.
- El emulador necesita al menos 4 GB libres en su partición de datos para instalar el APK de depuración.

Comprobaciones:

```powershell
flutter analyze
flutter test
```

## Organización

```text
lib/
  main.dart                       Arranque y tema
  theme/app_theme.dart            Colores y ThemeData
  models/menu.dart                Menú, estados y avisos
  data/menu_store.dart            Estado temporal (ChangeNotifier)
  screens/
    home_shell.dart               Scaffold, NavigationBar y botón flotante
    explore_tab.dart              Menús: búsqueda, filtros y lista
    radar_tab.dart                Radar animado con pines y vista previa
    community_tab.dart            Comunidad: cabecera y burbujas
    menu_detail_page.dart         Detalle con SliverAppBar
    publish_menu_page.dart        Formulario
  widgets/
    food_art.dart                 Ilustraciones de platos y banner por cocina
    menu_card.dart                Tarjeta de menú
    status_badge.dart             Indicador de disponibilidad
    availability_sheet.dart       Hoja inferior para avisar stock
    notice_composer.dart          Hoja para publicar un aviso en Comunidad
assets/fonts/                     Lilita One y Poppins (licencia OFL)
docs/
  analisis_y_layout.md            Árbol de problemas, diseño y widgets
  capturas/                       Capturas del emulador
```

## Documentación

- [Árbol de problemas, diseño de interfaces y widgets de layout](docs/analisis_y_layout.md)
- [Contexto del laboratorio](CONTEXTO_MENU_RADAR.md)

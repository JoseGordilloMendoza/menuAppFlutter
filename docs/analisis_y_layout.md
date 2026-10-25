# Análisis del problema y del layout

## 1. Problema abordado

**Problema central:** los estudiantes pierden parte del receso buscando presencialmente un menú económico que aún esté disponible cerca del campus.

Este árbol se formula a partir de la descripción del problema del trabajo previo MenúRadar. Las cifras allí expuestas se tratan como estimaciones del documento, no como resultados medidos por este prototipo.

| Causas | Problema central | Efectos |
|---|---|---|
| Información de platos y precios dispersa en pizarras físicas; disponibilidad cambiante sin aviso; poca posibilidad de comparar antes de salir. | Tiempo perdido al buscar un menú cercano, económico y disponible. | Caminatas innecesarias; frustración al encontrar platos agotados; menos tiempo para comer y descansar. |

## 2. Del problema a la interfaz

| Necesidad derivada | Funcionalidad | Interfaz | Widgets principales |
|---|---|---|---|
| Comparar opciones sin recorrer locales | Buscar y filtrar menús | Menús | `TextField`, `FilterChip`, `ListView`, `Card` |
| Conocer los detalles antes de elegir | Consultar platos, precio y referencia | Detalle | `Scaffold`, `ListView`, `Wrap`, `Card` |
| Evitar desplazarse a un local agotado | Ver y reportar disponibilidad | Tarjeta, detalle y hoja inferior | `Row`, `StatusBadge`, `showModalBottomSheet`, `ListTile` |
| Incorporar información nueva | Publicar un menú | Formulario | `Form`, `TextFormField`, `DropdownButtonFormField`, `SegmentedButton` |
| Consultar avisos recientes | Leer reportes de la comunidad | Comunidad | `ListView`, `Card`, `Column` |
| Explorar locales visualmente | Seleccionar pines referenciales | Radar | `LayoutBuilder`, `Stack`, `Positioned`, `CustomPaint` |

## 3. Componentes de organización y layout investigados

| Widget | Función en Flutter | Uso en el proyecto |
|---|---|---|
| `MaterialApp` | Define la aplicación, navegación y tema Material. | Raíz del proyecto. |
| `Scaffold` | Estructura una pantalla con cuerpo, barra y navegación. | Pantalla principal, detalle y publicación. |
| `SafeArea` | Evita que el contenido invada recortes y barras del sistema. | Cuerpo y acciones inferiores. |
| `Column` | Ordena elementos verticalmente. | Encabezados, formularios y tarjetas. |
| `Row` | Ordena elementos horizontalmente. | Precio junto al nombre, acciones y metadatos. |
| `Expanded` | Distribuye el espacio disponible dentro de `Row` o `Column`. | Lista principal y panel del radar. |
| `Padding` y `SizedBox` | Controlan separación y espacios constantes. | Márgenes, ritmo vertical y grupos de controles. |
| `ListView` | Muestra contenido desplazable y listas largas. | Menús, avisos y formulario. |
| `Wrap` | Acomoda elementos en otra línea si falta ancho. | Precio y estado en el detalle; leyenda del radar. |
| `Stack` y `Positioned` | Superponen elementos y ubican pines. | Radar ilustrativo. |
| `LayoutBuilder` | Adapta posiciones al espacio disponible. | Tamaño y ubicación de pines del radar. |
| `NavigationBar` | Cambia entre secciones principales. | Menús, radar y comunidad. |

**Reglas de layout aplicadas:** las listas reciben un espacio acotado mediante `Expanded`; los contenidos largos se desplazan con `ListView`; los chips se desplazan horizontalmente; el formulario usa validación y scroll; el radar usa medidas relativas en vez de coordenadas absolutas de pantalla.

## 4. Flujo de navegación

```text
Menús ──> Detalle ──> Avisar disponibilidad
  │
  └──────> Publicar menú ──> Menús

Radar ──> Detalle
Comunidad <── nuevos avisos de publicación o disponibilidad
```

## 5. Fuentes técnicas

- Flutter, [Layouts in Flutter](https://docs.flutter.dev/ui/layout).
- Flutter, [Layout widgets](https://docs.flutter.dev/ui/widgets/layout).
- Flutter, [Understanding constraints](https://docs.flutter.dev/ui/layout/constraints).
- Flutter, [Material components](https://docs.flutter.dev/ui/widgets/material).

Documento temático de referencia: *MenúRadar: Aplicativo Móvil Universitario para la Gestión en Tiempo Real de Menús Estudiantiles* (PDF facilitado por el usuario).

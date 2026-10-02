# Gestión PDV - Guía de contribución

## Objetivo

Aplicación Flutter para gestionar la jornada operativa de mercaderistas en puntos de venta. La versión actual es una maqueta funcional con datos locales demo.

## Stack

- Flutter stable con null safety.
- Material 3.
- `provider` y `ChangeNotifier` para estado.
- Repositorios locales en memoria.

## Arquitectura

El código usa una estructura feature-first:

```text
lib/app/                       # Arranque y rutas
lib/core/theme/                # Tema visual
lib/core/constants/            # Constantes cuando sean necesarias
lib/core/utils/                # Utilidades sin estado
lib/shared/widgets/            # Widgets transversales
lib/features/<feature>/data/   # Repositorios locales/remotos
lib/features/<feature>/models/ # Modelos tipados
lib/features/<feature>/providers/ # ChangeNotifier y reglas de negocio
lib/features/<feature>/presentation/ # Pantallas y widgets de UI
```

El flujo obligatorio es `Pantalla -> Provider -> Repositorio -> Modelos`. No colocar lógica de negocio importante ni mutaciones de datos directamente en widgets.

## Convenciones

- Interfaz visible: español.
- Código, clases, variables y archivos: inglés en `snake_case` para archivos y `PascalCase` para tipos.
- Mantener widgets pequeños y reutilizar componentes en `shared/widgets` cuando tengan más de un uso real.
- No crear interfaces, factories, servicios genéricos o capas extra sin una necesidad concreta.
- No agregar dependencias sin justificar una funcionalidad que Flutter o el código actual no cubran claramente.
- Si existe un módulo de evaluaciones, conservarlo aislado; no mezclarlo con Gestión PDV sin requerimiento explícito.

## Estado y datos

`AuthProvider`, `VisitasProvider` y `ExhibicionesProvider` son los puntos de entrada de estado. Los repositorios locales representan la futura frontera para Supabase, sin conectarse todavía a servicios externos.

No implementar aún Supabase, backend, API, GPS, mapas, cámara, subida de imágenes, notificaciones, sincronización offline real ni autenticación real.

## Diseño

- Fondo `#F7F9FA`, principal `#3E8E89`, texto `#20272B`, secundario `#6F7A80`.
- Éxito verde suave, pendiente ámbar suave y novedad rojo coral suave.
- Sin gradientes ni sombras fuertes.
- Usar Material 3, `SafeArea`, diseños adaptables y espaciado consistente.

## Comandos

```bash
flutter pub get
flutter run
flutter run -d chrome
flutter analyze
flutter test
```

## Nuevos módulos

Crear `data`, `models`, `providers` y `presentation` bajo `lib/features/<feature>`. Añadir únicamente las capas que el módulo use. Exponer las acciones desde el provider y mantener el repositorio como fuente de datos intercambiable.

## Integraciones previstas

Supabase, GPS, cámara, almacenamiento de evidencias y autenticación real se incorporarán cuando se defina el flujo y la base de datos.

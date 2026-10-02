# Gestión PDV

Maqueta Flutter multiplataforma para la gestión operativa de mercaderistas en puntos de venta.

## Primera versión

La aplicación permite iniciar sesión con un usuario demo, consultar la jornada, gestionar visitas, registrar exhibiciones y evidencias simuladas, reportar novedades, finalizar visitas y consultar el historial de la sesión.

Todos los datos son locales y viven en memoria mientras la aplicación está abierta. No hay backend, autenticación real, Supabase, GPS, mapas, cámara ni subida de imágenes.

## Funcionalidades implementadas

- Login simulado con validaciones.
- Resumen de jornada, progreso, próxima visita y alertas.
- Lista de ocho PDV ecuatorianos de demostración y filtros por estado.
- Inicio de visita con entrada y GPS simulados; solo una visita puede estar activa.
- Formulario de exhibición, evidencias visuales simuladas y validaciones.
- Registro de novedades y cierre confirmado de visitas.
- Historial actualizado durante la sesión y perfil con cierre de sesión confirmado.
- Estados de carga, vacío y error para la información local.

## Arquitectura

El flujo de cada módulo es `Pantalla -> Provider -> Repositorio local -> Modelos`.

```text
lib/
├── app/                 # Aplicación raíz y rutas
├── core/                # Tema y utilidades transversales
├── shared/widgets/      # Estados y componentes reutilizables
├── features/
│   ├── auth/
│   ├── home/
│   ├── visitas/
│   ├── exhibiciones/
│   ├── historial/
│   └── perfil/
└── main.dart
```

Se usa Material 3 y `provider` con `ChangeNotifier`. Los repositorios actuales usan listas en memoria y sus métodos están preparados para reemplazarse posteriormente por una fuente remota.

## Requisitos

- Flutter stable 3.44 o posterior.
- Dart incluido con Flutter.

## Ejecutar

```bash
flutter pub get
flutter run
```

Para Chrome:

```bash
flutter run -d chrome
```

Credenciales demo:

```text
Usuario: mercaderista@demo.com
Contraseña: 123456
```

## Calidad

```bash
flutter analyze
flutter test
```

## Próximos pasos

- Reemplazar repositorios locales por Supabase.
- Añadir autenticación real, GPS, cámara y almacenamiento de evidencias.
- Incorporar sincronización offline y notificaciones según las reglas operativas definidas.

## Decisiones técnicas

- Se evita añadir paquetes para GPS, cámara, mapas o persistencia mientras sean simulados.
- La lógica de negocio permanece en los proveedores; las pantallas solo presentan el estado y delegan acciones.
- No se mezclan módulos de evaluaciones con Gestión PDV.

# Rick and Morty CRUD - Aplicacion Flutter

## Integrantes

- Medina Mallqui, Ailyn
- Ochoa Marin, Yamile

## Descripcion general

Aplicacion movil desarrollada en Flutter que consume la API publica de Rick
and Morty y permite gestionar un CRUD completo (crear, leer, actualizar y
eliminar) sobre los personajes obtenidos. La informacion se persiste de
forma local mediante una base de datos SQLite, lo que permite que la
aplicacion funcione de manera consistente incluso si la conexion a internet
se pierde despues de la carga inicial.

## API consumida

- **Nombre:** Rick and Morty API
- **Endpoint base:** `https://rickandmortyapi.com/api/character`
- **Tipo:** API publica REST, de solo lectura (unicamente expone metodos GET)
- **Uso dentro de la aplicacion:** al iniciar la aplicacion por primera vez,
  se realiza una peticion HTTP GET para obtener personajes reales (nombre,
  estado, especie, genero, origen e imagen). Esta informacion se utiliza
  para poblar la base de datos local, que es la que finalmente respalda
  todas las operaciones del CRUD.


## Patron de arquitectura

El proyecto sigue una separacion por capas inspirada en el patron
**MVVM / Provider Pattern**

- **Model:** clases que representan las entidades del dominio
  (`models/character_model.dart`).
- **Service:** capa encargada de la comunicacion con fuentes de datos
  externas e internas: la API remota (`services/api_service.dart`) y la
  base de datos local (`services/database_service.dart`).
- **Provider (ViewModel):** clase `CharacterProvider`, que extiende
  `ChangeNotifier` y concentra el estado y la logica de negocio de la
  aplicacion (busqueda, filtros, operaciones CRUD), notificando a la
  interfaz cuando el estado cambia.
- **View:** pantallas (`screens/`) y widgets reutilizables (`widgets/`),
  que solo se encargan de la presentacion y reaccionan a los cambios de
  estado del Provider mediante `Consumer` y `context.read` / `context.watch`.


## Tecnologias y paquetes utilizados

| Paquete | Uso |
|---|---|
| `http` | Consumo de la API REST de Rick and Morty |
| `provider` | Gestion de estado con el patron Provider |
| `sqflite` | Persistencia local de datos (CRUD) |
| `path` / `path_provider` | Manejo de rutas para la base de datos local |
| `cached_network_image` | Carga y cacheo de imagenes remotas |
| `google_fonts` | Tipografia personalizada (Poppins y Playfair Display) |

## Estructura del proyecto

```
lib/
  core/
    constants/
      api_constants.dart        Constantes de endpoints de la API
    theme/
      app_colors.dart           Paleta de colores de la aplicacion
      app_theme.dart            Tema global (tipografia, botones, inputs)
  models/
    character_model.dart        Entidad Character (mapeo API y SQLite)
  services/
    api_service.dart            Consumo de la API de Rick and Morty
    database_service.dart       Operaciones CRUD sobre SQLite
  providers/
    character_provider.dart     Estado global y logica de negocio (CRUD)
  screens/
    home_screen.dart            Listado, busqueda y filtros de personajes
    character_detail_screen.dart Detalle de un personaje
    character_form_screen.dart  Formulario de creacion y edicion
  widgets/
    character_card.dart         Tarjeta de personaje en la grilla
    status_badge.dart           Indicador visual de estado (vivo/muerto)
    empty_state.dart            Estado vacio y manejo visual de errores
    custom_text_field.dart      Campo de texto reutilizable para formularios
  main.dart                     Punto de entrada de la aplicacion
```

## Funcionalidades CRUD

- **Create:** formulario para registrar un nuevo personaje con nombre,
  especie, estado, genero, origen e imagen.
- **Read:** listado de personajes en formato de grilla, con busqueda por
  nombre y filtro por estado (vivo, muerto, desconocido).
- **Update:** edicion de cualquier campo de un personaje existente desde su
  pantalla de detalle.
- **Delete:** eliminacion de un personaje con dialogo de confirmacion
  previo.
- **Sincronizacion:** accion de "pull to refresh" en la pantalla principal
  para obtener personajes adicionales desde la API sin duplicar los que ya
  existen en la base de datos local.

## Instalacion y ejecucion

1. Instalar las dependencias del proyecto:

   ```
   flutter pub get
   ```

2. Si el proyecto no incluye las carpetas nativas (android, ios), generarlas
   sin sobrescribir el codigo existente:

   ```
   flutter create .
   ```

3. Verificar que el `AndroidManifest.xml` (`android/app/src/main/AndroidManifest.xml`)
   incluya el permiso de internet:

   ```xml
   <uses-permission android:name="android.permission.INTERNET" />
   ```

4. Conectar un emulador o dispositivo fisico y ejecutar:

   ```
   flutter run
   ```

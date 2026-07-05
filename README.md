# Rick and Morty CRUD

Aplicacion Flutter que consume la API publica de Rick and Morty y permite
gestionar un CRUD completo (crear, leer, actualizar, eliminar) sobre los
personajes, persistiendo los cambios en una base de datos local SQLite.

## Como funciona

1. En el primer arranque, la app descarga personajes desde
   `https://rickandmortyapi.com/api/character` y los guarda en SQLite.
2. Toda la gestion posterior (crear, editar, eliminar) se hace sobre esa base
   local, que es la fuente de verdad de la app.
3. Deslizando hacia abajo en la pantalla principal (pull to refresh) se
   sincronizan personajes nuevos desde la API sin duplicar los existentes.

## Estructura del proyecto

```
lib/
  core/
    constants/api_constants.dart
    theme/app_colors.dart
    theme/app_theme.dart
  models/
    character_model.dart
  services/
    api_service.dart
    database_service.dart
  providers/
    character_provider.dart
  screens/
    home_screen.dart
    character_detail_screen.dart
    character_form_screen.dart
  widgets/
    character_card.dart
    status_badge.dart
    empty_state.dart
    custom_text_field.dart
  main.dart
```

## Paso a paso para correrlo

1. Instala las dependencias:

```
flutter pub get
```

2. Si el proyecto no trae las carpetas nativas (android, ios, etc.), genera
   las plataformas sin tocar lib/ ni pubspec.yaml:

```
flutter create .
```

3. Conecta un emulador o celular y corre:

```
flutter run
```

## Si no aparece ningun personaje

Casi siempre es uno de estos dos motivos:

1. **Falta el permiso de internet en Android.** Cuando generas las carpetas
   nativas con `flutter create .`, el `AndroidManifest.xml` que se crea NO
   incluye el permiso de internet por defecto. Abre
   `android/app/src/main/AndroidManifest.xml` y agrega esta linea dentro de
   la etiqueta `<manifest ...>`, antes de `<application ...>`:

   ```xml
   <uses-permission android:name="android.permission.INTERNET" />
   ```

   Sin esa linea, las peticiones a la API fallan en silencio (excepcion de
   socket) y la app se queda sin datos.

2. **El emulador no tiene internet.** Prueba abrir un navegador dentro del
   emulador o corre `flutter run` y revisa la consola: si ves un error de
   `SocketException` o `ClientException`, es un tema de red del emulador, no
   del codigo.

Si el problema persiste, ahora la pantalla principal muestra el mensaje de
error real (con boton "Reintentar") en vez de un simple "no hay personajes",
para que sea mas facil detectar la causa.

## Notas tecnicas

- Gestion de estado con `provider`.
- Persistencia local con `sqflite`.
- Imagenes remotas cacheadas con `cached_network_image`.
- Tipografia con `google_fonts` (Poppins).
- Paleta de color monocromatica en tonos vino/borgoña, definida en
  `lib/core/theme/app_colors.dart`.

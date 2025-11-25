# QR Master

QR Master es un lector de códigos QR y escáner de códigos de barras **rápido y sin conexión** que mantiene tus datos **en tu dispositivo, no en la nube**.

Escanea cualquier código QR o código de barras en segundos: enlaces web, Wi-Fi, contactos, texto plano y más. Solo apunta la cámara y QR Master lee el código al instante, incluso sin conexión a internet.

También puedes **crear códigos QR personalizados** para enlaces, textos, redes Wi-Fi, números de teléfono o mensajes en pocos toques. Ideal para uso personal, pequeños negocios, menús, volantes, etiquetas de productos y mucho más.

Toda la información que lees o generas se guarda de forma segura en el teléfono usando base de datos local (`floor`).  
**No recopilamos ni subimos tus datos a servidores externos**: tú mantienes el control de tu información.

---

## ✨ Características

- 🔍 **Lector de QR y códigos de barras**
  - Escaneo rápido con la cámara del dispositivo.
  - Soporte para texto, enlaces, Wi-Fi, contacto, teléfono y más.
  - Funciona incluso **sin conexión a internet**.

- 🧾 **Generador de códigos QR**
  - Crea códigos QR personalizados:
    - Enlaces (URL)
    - Texto plano
    - Redes Wi-Fi
    - Números de teléfono / mensajes
  - Ideal para negocio local, anuncios, etiquetas, etc.

- 💾 **Datos almacenados localmente**
  - Historial de escaneos y códigos generados guardados en la base de datos local (`floor`).
  - Nada se envía a la nube por diseño.

- 🧱 **Arquitectura MVC**
  - Separación clara entre:
    - **Model**: entidades, repositorios, acceso a datos.
    - **View**: pantallas Flutter (UI).
    - **Controller**: lógica de presentación y orquestación.
  - Facilita mantenimiento, escalabilidad y pruebas.

- 🗺️ **Extras opcionales**
  - Integración con Google Maps (`google_maps_flutter`).
  - Uso de geolocalización (`geolocator`).
  - Integración con anuncios (`google_mobile_ads`).
  - Notificaciones locales (`flutter_local_notifications`) y push (`firebase_messaging`).

---

## 🧩 Tecnologías y paquetes principales

- **Flutter** + **Dart** (SDK `^3.9.2`)
- Patrón de arquitectura **MVC**
- **Gestión de estado / inyección de dependencias**
  - `provider`
  - `get_it`
- **Base de datos local**
  - `floor` + `floor_generator` + `build_runner`
- **UI y utilidades**
  - `flutter_native_splash`
  - `flutter_launcher_icons`
  - `android_notification_icons`
  - `another_flushbar`, `font_awesome_flutter`, `line_awesome_flutter`
  - `flutter_colorpicker`
- **QR & códigos de barras**
  - `mobile_scanner`
  - `qr_flutter`
  - `barcode`
- **Navegación / integración nativa**
  - `url_launcher`
  - `image_picker`
  - `path_provider`
- **Ads & Firebase (opcional)**
  - `google_mobile_ads`
  - `firebase_core`
  - `firebase_analytics`
  - `firebase_messaging`
- **Otros**
  - `share_plus`
  - `pdf`
  - `geolocator`
  - `flutter_localizations` + `i18n_extension` para multi-idioma

---

## 📁 Arquitectura MVC (visión general)

El proyecto sigue una arquitectura **MVC (Model–View–Controller)**:

- **Model**
  - Definición de entidades/datos.
  - DAOs y repositorios usando `floor`.
  - Lógica de acceso a la base de datos local.

- **View**
  - Widgets y pantallas Flutter.
  - Componentes visuales y temas (colores, fuentes, etc.).

- **Controller**
  - Orquesta la lógica de negocio entre Model y View.
  - Usa `provider` + `get_it` para exponer estados/controladores a la UI.

> La estructura exacta de carpetas puede variar, pero la idea es mantener separadas responsabilidades y facilitar el mantenimiento.

---

## 🚀 Empezar

### 1. Requisitos

- Flutter instalado (canal estable).
- Dart SDK compatible (mínimo `3.9.2` según `pubspec.yaml`).
- Android SDK configurado.
- Dispositivo físico o emulador Android.

### 2. Clonar el proyecto

```bash
git clone <URL_DEL_REPO>
cd qr_master
```

### 3. Instalar dependencias

```bash
flutter pub get
```

---

## 🗃️ Base de datos local con Floor

QR Master usa **Floor** como ORM para persistir datos localmente.

### Generar código de Floor

Cada vez que cambies entidades/DAOs anotados con `@entity`, `@dao`, etc., ejecuta:

```bash
dart run build_runner build --delete-conflicting-outputs
```

O si quieres modo watch durante desarrollo:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

Esto generará los archivos `.g.dart` necesarios para que Floor funcione.

---

## 🎨 Iconos, Splash y Notificaciones

### 1. Iconos del launcher (`flutter_launcher_icons`)

Configurado en `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  image_path: "assets/img/logo.png"
```

Generar los iconos:

```bash
dart run flutter_launcher_icons
```

Si quieres forzar sobreescritura:

```bash
dart run flutter_launcher_icons:generate --override
```

---

### 2. Splash Screen (`flutter_native_splash`)

Configuración en `pubspec.yaml`:

```yaml
flutter_native_splash:
  color: "#0D1826"
  color_dark: "#0D1826"
  image: "assets/img/logo_splash.png"
  image_dark: "assets/img/logo_splash.png"
  android: true
  android_gravity: center
  fullscreen: true
  android_12:
    image: assets/img/logo_splash.png
    image_dark: assets/img/logo_splash.png
```

Generar el splash:

```bash
dart run flutter_native_splash:create
```

> Si cambias el logo o colores, vuelve a ejecutar el comando.

---

### 3. Iconos de notificación (`android_notification_icons`)

Configuración en `pubspec.yaml`:

```yaml
android_notification_icons:
  image_path: 'assets/img/logo.png'
  icon_name: 'ic_notification'
```

Generar iconos para notificaciones:

```bash
dart run android_notification_icons:generate
```

> Estos iconos los usa `flutter_local_notifications` y/o `firebase_messaging` para notificaciones locales/push.

---

## 🌍 Localización (multi-idioma)

El proyecto usa:

- `flutter_localizations`
- `i18n_extension`

Para agregar o actualizar traducciones:

1. Asegúrate de tener configurado `localizationsDelegates` y `supportedLocales` en `MaterialApp`.
2. Usa `i18n_extension` para manejar strings según el idioma.
3. Actualiza archivos de traducción cuando añadas nuevos textos.

---

## ▶️ Ejecutar la app

### Modo debug

```bash
flutter run
```

Puedes especificar un dispositivo, por ejemplo:

```bash
flutter run -d CPH2251
```

### Build APK (release)

```bash
flutter build apk --release
```

### Build App Bundle (Play Store)

```bash
flutter build appbundle --release
```

> Asegúrate de tener configurada la firma (`signingConfigs`) y el `keystore` en `android/app/build.gradle.kts`.

---

## 🔐 Privacidad y datos

- Todas las lecturas y códigos generados se guardan **localmente** en tu dispositivo.
- No subimos tus datos a nuestros servidores.
- No usamos sincronización en la nube.
- Ads y servicios externos (como Google Mobile Ads o Firebase Analytics) se utilizan sin asociar tu contenido privado de escaneos/códigos.

---

## 🛠️ Scripts útiles (resumen)

```bash
# Instalar dependencias
flutter pub get

# Generar código de Floor
dart run build_runner build --delete-conflicting-outputs

# (opcional) en modo watch
dart run build_runner watch --delete-conflicting-outputs

# Generar iconos del launcher
dart run flutter_launcher_icons

# Generar Splash Screen
dart run flutter_native_splash:create

# Generar iconos de notificación
dart run android_notification_icons:generate

# Ejecutar app en debug
flutter run

# Build APK release
flutter build apk --release

# Build App Bundle release
flutter build appbundle --release
```

---

## 📄 Licencia

> (Añade aquí la licencia que deseas usar: MIT, Apache 2.0, etc.)

---

## 🤝 Contribuir

1. Haz un fork del repositorio.
2. Crea una rama nueva: `git checkout -b feature/nueva-funcionalidad`.
3. Aplica tus cambios siguiendo el patrón MVC.
4. Ejecuta los generadores (`build_runner`, icons, splash si aplica).
5. Envía un pull request.

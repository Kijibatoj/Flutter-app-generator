# Flutter App Base Generator - Proceso Completo

## Índice
1. [Descripción General](#descripción-general)
2. [Arquitectura del Generador](#arquitectura-del-generador)
3. [Comandos Disponibles](#comandos-disponibles)
4. [Proceso de Generación](#proceso-de-generación)
5. [Estructura de Carpetas Generadas](#estructura-de-carpetas-generadas)
6. [Templates y Componentes](#templates-y-componentes)
7. [Opciones de Configuración](#opciones-de-configuración)
8. [Flujo de Trabajo](#flujo-de-trabajo)
9. [Casos de Uso](#casos-de-uso)
10. [Troubleshooting](#troubleshooting)

---

## Descripción General

**Flutter App Base Generator** es una librería CLI que automatiza la creación de aplicaciones Flutter completas con arquitectura profesional, componentes modernos y funcionalidades avanzadas.

### Características Principales
- Generación de apps funcionales completas
- Arquitectura limpia (Clean Architecture)
- Componentes neumórficos modernos
- Sistema de autenticación completo
- Navegación configurada
- Almacenamiento seguro
- Gestión de estado con BLoC/Cubit
- Formularios con validación avanzada
- Temas profesionales
- CLI inteligente para automatización

---

## Arquitectura del Generador

### Estructura del Proyecto
```
flutter_app_base_generator/
├── bin/
│   └── flutter_app_gen.dart          # Punto de entrada CLI
├── lib/
│   ├── flutter_app_base_generator.dart
│   └── src/
│       ├── flutter_app_base_generator_base.dart  # Lógica principal
│       ├── generators/
│       │   └── app_generator.dart    # Generador de aplicaciones
│       ├── models/
│       │   └── generator_options.dart # Opciones de configuración
│       ├── templates/                 # Templates de código
│       │   ├── auth_templates.dart
│       │   ├── splash_templates.dart
│       │   ├── home_templates.dart
│       │   ├── api_templates.dart
│       │   ├── state_templates.dart
│       │   ├── shared_templates.dart
│       │   ├── core_templates.dart
│       │   ├── theme_templates.dart
│       │   ├── routing_templates.dart
│       │   ├── working_templates.dart
│       │   ├── additional_components_templates.dart
│       │   └── neumorphic_components_templates.dart
│       └── utils/
│           ├── console_utils.dart     # Utilidades de consola
│           └── file_utils.dart        # Utilidades de archivos
```

### Flujo de Procesamiento
1. **CLI Entry Point** → `bin/flutter_app_gen.dart`
2. **Argument Parsing** → `flutter_app_base_generator_base.dart`
3. **Command Routing** → Métodos específicos en `app_generator.dart`
4. **Template Generation** → Templates específicos según el comando
5. **File Creation** → `file_utils.dart` para crear archivos
6. **Console Output** → `console_utils.dart` para feedback

---

## Comandos Disponibles

### Comandos Principales
```bash
# Generar componentes
flutter_app_gen generate <tipo> [nombre] [opciones]

# Inicializar proyecto
flutter_app_gen init

# Configurar herramientas
flutter_app_gen setup <tipo>

# Ayuda y versión
flutter_app_gen help
flutter_app_gen version
```

### Tipos de Generación
| Comando | Descripción | Estructura Generada |
|---------|-------------|-------------------|
| `full-app` | Aplicación completa | Estructura completa con todas las features |
| `auth` | Autenticación | Login, registro, recuperación de contraseña |
| `splash` | Pantalla de carga | SplashScreen con animaciones |
| `onboarding` | Tutorial inicial | Flujo de onboarding con múltiples páginas |
| `home` | Pantalla principal | HomeScreen con navegación |
| `api` | Configuración API | Servicios HTTP, interceptors, conectividad |
| `feature` | Feature personalizada | Estructura limpia para features específicas |

---

## Proceso de Generación

### 1. Análisis de Comandos
```dart
// El CLI analiza los argumentos
final command = arguments[0];  // 'generate'
final type = args[0];          // 'full-app', 'auth', etc.
final name = args[1];          // Nombre de la app/feature
final options = parseOptions(); // Opciones de configuración
```

### 2. Validación de Parámetros
- Verificación de nombres válidos
- Validación de opciones de configuración
- Comprobación de dependencias

### 3. Creación de Estructura
```dart
await _createDirectoryStructure([
  'lib/features/auth/presentation/screens',
  'lib/features/auth/presentation/cubit',
  'lib/features/auth/domain/entities',
  // ... más carpetas
]);
```

### 4. Generación de Templates
```dart
// Cada template genera código específico
final authTemplates = AuthTemplates();
await FileUtils.writeFile(
  'lib/features/auth/presentation/screens/login_screen.dart',
  authTemplates.generateLoginScreen(name, options),
);
```

### 5. Configuración de Dependencias
- Generación de `pubspec.yaml`
- Configuración de dependencias necesarias
- Archivos de configuración (.env, etc.)

---

## Estructura de Carpetas Generadas

### Para `full-app` (Aplicación Completa)
```
MiApp/
├── lib/
│   ├── main.dart                    # Punto de entrada
│   ├── configs/
│   │   ├── config.dart              # Configuración general
│   │   ├── constants/
│   │   │   ├── env.dart             # Variables de entorno
│   │   │   └── secure_storage.dart  # Almacenamiento seguro
│   │   └── theme/
│   │       └── app_theme.dart       # Tema de la aplicación
│   ├── controllers/
│   │   └── users.dart               # Controladores
│   ├── screen/
│   │   ├── splash/
│   │   │   └── splash_screen.dart   # Pantalla de carga
│   │   ├── auth/
│   │   │   └── login_screen.dart    # Pantalla de login
│   │   └── home/
│   │       ├── home_screen.dart     # Pantalla principal
│   │       └── modules/
│   │           ├── home_section.dart
│   │           └── profile_section.dart
│   └── shared/
│       ├── common/
│       │   ├── common.dart          # Utilidades comunes
│       │   ├── check_internet.dart  # Verificación de internet
│       │   ├── data_user.dart       # Modelo de usuario
│       │   └── helper.dart          # Funciones auxiliares
│       └── widgets/
│           ├── forms/
│           │   └── label_text_form_field.dart
│           └── side_menu.dart       # Menú lateral
├── assets/
│   ├── images/                      # Imágenes
│   ├── icons/                       # Iconos
│   └── fonts/                       # Fuentes
├── pubspec.yaml                     # Dependencias
└── .env                            # Variables de entorno
```

### Para `auth` (Clean Architecture)
```
lib/features/auth/
├── data/
│   ├── datasources/                 # Fuentes de datos
│   ├── models/                      # Modelos de datos
│   └── repositories/                # Implementaciones de repositorios
├── domain/
│   ├── entities/                    # Entidades de dominio
│   ├── repositories/                # Interfaces de repositorios
│   └── usecases/                    # Casos de uso
└── presentation/
    ├── cubit/                       # Gestión de estado
    ├── screens/                     # Pantallas
    └── widgets/                     # Widgets específicos
```

### Para `neumorphic-components`
```
lib/shared/
├── widgets/neumorphic/
│   ├── neumorphic_button.dart       # Botones neumórficos
│   ├── neumorphic_container.dart    # Contenedores neumórficos
│   └── neumorphic_text_field.dart   # Campos de texto neumórficos
├── theme/neumorphic/
│   └── neumorphic_theme.dart        # Tema neumórfico
└── utils/neumorphic/
    └── component_inserter.dart      # Sistema de análisis
```

---

## Templates y Componentes

### Templates Disponibles

#### 1. AuthTemplates (auth_templates.dart)
- `generateLoginScreen()` - Pantalla de login
- `generateRegisterScreen()` - Pantalla de registro
- `generateRecoveryScreen()` - Recuperación de contraseña
- `generateAuthCubit()` - Gestión de estado de autenticación
- `generateUserEntity()` - Entidad de usuario
- `generateUserModel()` - Modelo de usuario

#### 2. SplashTemplates (splash_templates.dart)
- `generateSplashScreen()` - Pantalla de carga
- `generateOnboardingScreen()` - Flujo de onboarding

#### 3. HomeTemplates (home_templates.dart)
- `generateHomeScreen()` - Pantalla principal
- `generateAppDrawer()` - Menú lateral
- `generateHomeCubit()` - Gestión de estado del home

#### 4. ApiTemplates (api_templates.dart)
- `generateApiService()` - Servicio de API
- `generateSecureStorage()` - Almacenamiento seguro
- `generateConnectivityService()` - Verificación de conectividad

#### 5. WorkingTemplates (working_templates.dart)
- `generateWorkingMain()` - Main.dart funcional
- `generateConfig()` - Configuración general
- `generateEnv()` - Variables de entorno
- `generateSecureStorage()` - Almacenamiento seguro
- `generateUsersController()` - Controlador de usuarios

#### 6. NeumorphicComponentsTemplates (neumorphic_components_templates.dart)
- `generateNeumorphicTheme()` - Tema neumórfico
- `generateNeumorphicButton()` - Botones neumórficos
- `generateNeumorphicContainer()` - Contenedores neumórficos
- `generateNeumorphicTextField()` - Campos de texto neumórficos
- `generateCommandSystem()` - Sistema de comandos CLI

### Componentes Neumórficos
```dart
// Botón neumórfico
NeumorphicButton.text(
  text: "Mi Botón",
  onPressed: () {},
  style: NeumorphicTheme.styleFor(context),
)

// Campo de texto neumórfico
NeumorphicTextField(
  hintText: "Ingresa tu texto",
  labelText: "Campo",
  style: NeumorphicTheme.styleFor(context),
)
```

---

## Opciones de Configuración

### Opciones Generales
| Opción | Descripción | Valores | Default |
|--------|-------------|---------|---------|
| `--clean-architecture` | Usar arquitectura limpia | true/false | true |
| `--include-animations` | Incluir animaciones | true/false | true |
| `--include-recovery` | Incluir recuperación de contraseña | true/false | true |
| `--include-notifications` | Incluir sistema de notificaciones | true/false | true |
| `--use-dio` | Usar Dio para HTTP | true/false | true |
| `--include-interceptors` | Incluir interceptors HTTP | true/false | true |
| `--include-secure-storage` | Incluir almacenamiento seguro | true/false | true |
| `--include-connectivity` | Incluir verificación de conectividad | true/false | true |

### Opciones de Navegación
| Opción | Descripción | Valores | Default |
|--------|-------------|---------|---------|
| `--navigation-type` | Tipo de navegación | bottom/sidebar/both | bottom |
| `--tabs-count` | Número de tabs | 1-10 | 3 |

### Opciones de Onboarding
| Opción | Descripción | Valores | Default |
|--------|-------------|---------|---------|
| `--pages-count` | Número de páginas | 1-10 | 3 |
| `--animation-duration` | Duración de animaciones | 1-10 | 3 |

### Opciones de API
| Opción | Descripción | Valores | Default |
|--------|-------------|---------|---------|
| `--base-url` | URL base de la API | URL válida | https://api.example.com |

---

## Flujo de Trabajo

### 1. Instalación y Configuración
```bash
# Instalar la librería
dart pub global activate --source path .

# Configurar PATH (Windows)
configure_path.bat

# Verificar instalación
flutter_app_gen --version
```

### 2. Generación de Aplicación
```bash
# Generar app completa
flutter_app_gen generate full-app MiApp

# Generar app con componentes neumórficos
flutter_app_gen generate full-app-with-neumorphic MiApp

# Generar componentes específicos
flutter_app_gen generate auth --clean-architecture
flutter_app_gen generate home --navigation-type=sidebar
```

### 3. Configuración Post-Generación
```bash
# Navegar al proyecto
cd MiApp

# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run
```

### 4. Personalización
- Modificar temas en `lib/configs/theme/`
- Configurar API en `lib/configs/constants/env.dart`
- Personalizar pantallas en `lib/screen/`
- Agregar nuevas features en `lib/features/`

---

## Casos de Uso

### Caso 1: Aplicación Básica
```bash
# Generar app estándar
flutter_app_gen generate full-app MiAppBasica

# Resultado: App funcional con login, home, splash
```

### Caso 2: Aplicación con Componentes Modernos
```bash
# Generar app con neumórficos
flutter_app_gen generate full-app-with-neumorphic MiAppModerna

# Resultado: App con componentes neumórficos y análisis inteligente
```

### Caso 3: Feature Específica
```bash
# Generar solo autenticación
flutter_app_gen generate auth MiAuth --clean-architecture

# Resultado: Feature de auth completa con Clean Architecture
```

### Caso 4: Componentes Adicionales
```bash
# Generar componentes neumórficos
flutter_app_gen generate neumorphic-components

# Resultado: Biblioteca de componentes neumórficos
```

---

## Troubleshooting

### Problemas Comunes

#### 1. Comando no reconocido
```bash
# Solución: Verificar PATH
echo %PATH% | findstr "Pub\\Cache\\bin"

# Si no está, ejecutar:
configure_path.bat
```

#### 2. Error de dependencias
```bash
# Solución: Reinstalar
dart pub global activate --source path . --force
```

#### 3. Error de permisos
```bash
# Solución: Ejecutar como administrador
# O cambiar permisos de carpeta
```

#### 4. Error de templates
```bash
# Solución: Verificar archivos de template
# Reinstalar la librería
```

### Logs y Debugging
```bash
# Ver logs detallados
flutter_app_gen generate full-app MiApp --verbose

# Verificar estructura generada
tree MiApp/
```

---

## Conclusión

**Flutter App Base Generator** es una herramienta poderosa que automatiza la creación de aplicaciones Flutter profesionales, ahorrando tiempo de desarrollo y asegurando mejores prácticas de arquitectura y diseño.

### Beneficios Clave
- **Rapidez**: Genera apps completas en segundos
- **Arquitectura**: Clean Architecture por defecto
- **Diseño**: Componentes modernos y profesionales
- **Flexibilidad**: Altamente configurable
- **Funcionalidad**: Apps listas para usar
- **Escalabilidad**: Estructura preparada para crecimiento

### Próximas Características
- [ ] Generación de tests automáticos
- [ ] Integración con Firebase o supabase
- [ ] Soporte para múltiples idiomas
- [ ] Generación de documentación automática
- [ ] Generación de un StoryBook.
- [ ] Templates para diferentes tipos de apps
---


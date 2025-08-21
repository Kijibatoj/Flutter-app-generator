import 'dart:io';
import '../utils/console_utils.dart';
import '../utils/file_utils.dart';
import '../templates/auth_templates.dart';
import '../templates/splash_templates.dart';
import '../templates/home_templates.dart';
import '../templates/api_templates.dart';
import '../templates/state_templates.dart';
import '../templates/shared_templates.dart';
import '../templates/core_templates.dart';
import '../templates/theme_templates.dart';
import '../templates/routing_templates.dart';
import '../templates/working_templates.dart';
import '../templates/additional_components_templates.dart';
import '../templates/neumorphic_components_templates.dart';

class AppGenerator {
  
  /// Genera feature de autenticación completa
  Future<void> generateAuth(String name, Map<String, dynamic> options) async {
    ConsoleUtils.info('🔐 Generando feature de autenticación: $name');
    
    final cleanArch = options['clean-architecture'] ?? true;
    final includeRecovery = options['include-recovery'] ?? true;
    // final includeSocial = options['include-social'] ?? false; // TODO: Implement social login
    
    final basePath = 'lib/features/$name';
    
    if (cleanArch) {
      await _createDirectoryStructure([
        '$basePath/data/datasources',
        '$basePath/data/models',
        '$basePath/data/repositories',
        '$basePath/domain/entities',
        '$basePath/domain/repositories',
        '$basePath/domain/usecases',
        '$basePath/presentation/cubit',
        '$basePath/presentation/screens',
        '$basePath/presentation/widgets',
      ]);
    } else {
      await _createDirectoryStructure([
        '$basePath/screens',
        '$basePath/widgets',
        '$basePath/services',
      ]);
    }

    // Generar archivos usando templates
    final authTemplates = AuthTemplates();
    
    await FileUtils.writeFile(
      '$basePath/presentation/screens/login_screen.dart',
      authTemplates.generateLoginScreen(name, options),
    );
    
    await FileUtils.writeFile(
      '$basePath/presentation/screens/register_screen.dart',
      authTemplates.generateRegisterScreen(name, options),
    );
    
    if (includeRecovery) {
      await FileUtils.writeFile(
        '$basePath/presentation/screens/recovery_screen.dart',
        authTemplates.generateRecoveryScreen(name, options),
      );
    }

    if (cleanArch) {
      await FileUtils.writeFile(
        '$basePath/presentation/cubit/auth_cubit.dart',
        authTemplates.generateAuthCubit(name, options),
      );
      
      await FileUtils.writeFile(
        '$basePath/presentation/cubit/auth_state.dart',
        StateTemplates.generateAuthState(),
      );
      
      await FileUtils.writeFile(
        '$basePath/domain/entities/user.dart',
        authTemplates.generateUserEntity(name, options),
      );
      
      await FileUtils.writeFile(
        '$basePath/data/models/user_model.dart',
        authTemplates.generateUserModel(name, options),
      );
    }

    ConsoleUtils.success('✅ Feature de autenticación generado exitosamente!');
    _showNextSteps('auth', name);
  }

  /// Genera feature de onboarding
  Future<void> generateOnboarding(String name, Map<String, dynamic> options) async {
    ConsoleUtils.info('📖 Generando feature de onboarding: $name');
    
    // final pagesCount = options['pages-count'] ?? 3; // TODO: Use for dynamic page count
    // final includeSkip = options['include-skip'] ?? true; // TODO: Implement skip functionality
    // final includeAnimations = options['include-animations'] ?? true; // TODO: Make animations conditional
    final useCubit = options['use-cubit'] ?? true;
    
    final basePath = 'lib/features/$name';
    await _createDirectoryStructure([
      '$basePath/presentation/screens',
      '$basePath/presentation/cubit',
      '$basePath/presentation/widgets',
    ]);

    final splashTemplates = SplashTemplates();
    
    await FileUtils.writeFile(
      '$basePath/presentation/screens/onboarding_screen.dart',
      splashTemplates.generateOnboardingScreen(name, options),
    );

    if (useCubit) {
      await FileUtils.writeFile(
        '$basePath/presentation/cubit/onboarding_cubit.dart',
        _generateOnboardingCubit(name),
      );
      
      await FileUtils.writeFile(
        '$basePath/presentation/cubit/onboarding_state.dart',
        StateTemplates.generateOnboardingState(),
      );
    }

    ConsoleUtils.success('✅ Feature de onboarding generado exitosamente!');
    _showNextSteps('onboarding', name);
  }

  /// Genera SplashScreen con animaciones
  Future<void> generateSplash(String name, Map<String, dynamic> options) async {
    ConsoleUtils.info('🌟 Generando SplashScreen: $name');
    
    // final includeAnimations = options['include-animations'] ?? true; // TODO: Make animations conditional
    // final animationDuration = options['animation-duration'] ?? 3; // TODO: Make duration configurable
    
    final basePath = 'lib/features/splash';
    await _createDirectoryStructure([
      '$basePath/presentation/screens',
    ]);

    final splashTemplates = SplashTemplates();
    
    await FileUtils.writeFile(
      '$basePath/presentation/screens/splash_screen.dart',
      splashTemplates.generateSplashScreen(name, options),
    );

    ConsoleUtils.success('✅ SplashScreen generado exitosamente!');
    _showNextSteps('splash', name);
  }

  /// Genera feature Home con navegación
  Future<void> generateHome(String name, Map<String, dynamic> options) async {
    ConsoleUtils.info('🏠 Generando HomeScreen: $name');
    
    // final navigationType = options['navigation-type'] ?? 'bottom'; // TODO: Implement navigation types
    // final tabsCount = options['tabs-count'] ?? 3; // TODO: Make tabs count dynamic
    final includeNotifications = options['include-notifications'] ?? true;
    
    final basePath = 'lib/features/$name';
    await _createDirectoryStructure([
      '$basePath/presentation/screens',
      '$basePath/presentation/widgets',
      '$basePath/presentation/cubit',
    ]);

    final homeTemplates = HomeTemplates();
    
    await FileUtils.writeFile(
      '$basePath/presentation/screens/home_screen.dart',
      homeTemplates.generateHomeScreen(name, options),
    );
    
    await FileUtils.writeFile(
      '$basePath/presentation/widgets/app_drawer.dart',
      homeTemplates.generateAppDrawer(name, options),
    );
    
    if (includeNotifications) {
      await FileUtils.writeFile(
        '$basePath/presentation/cubit/home_cubit.dart',
        homeTemplates.generateHomeCubit(name, options),
      );
      
      await FileUtils.writeFile(
        '$basePath/presentation/cubit/home_state.dart',
        StateTemplates.generateHomeState(),
      );
    }

    ConsoleUtils.success('✅ HomeScreen generado exitosamente!');
    _showNextSteps('home', name);
  }

  /// Genera configuración de API
  Future<void> generateApiConnection(String name, Map<String, dynamic> options) async {
    ConsoleUtils.info('🌐 Generando configuración de API: $name');
    
    // final useDio = options['use-dio'] ?? true; // TODO: Make HTTP client configurable
    // final includeInterceptors = options['include-interceptors'] ?? true; // TODO: Make interceptors conditional
    final includeStorage = options['include-secure-storage'] ?? true;
    
    await _createDirectoryStructure([
      'lib/core/network',
      'lib/core/database',
      'lib/core/storage',
    ]);

    final apiTemplates = ApiTemplates();
    
    await FileUtils.writeFile(
      'lib/core/network/${name}_service.dart',
      apiTemplates.generateApiService(name, options),
    );
    
    if (includeStorage) {
      await FileUtils.writeFile(
        'lib/core/storage/secure_storage.dart',
        apiTemplates.generateSecureStorage(),
      );
    }
    
    await FileUtils.writeFile(
      'lib/core/network/connectivity_service.dart',
      apiTemplates.generateConnectivityService(),
    );

    ConsoleUtils.success('✅ Configuración de API generada exitosamente!');
    _showNextSteps('api', name);
  }

  /// Genera feature genérico
  Future<void> generateFeature(String name, Map<String, dynamic> options) async {
    ConsoleUtils.info('🔧 Generando feature genérico: $name');
    
    final useCleanArch = options['clean-architecture'] ?? true;
    final includeCubit = options['include-cubit'] ?? true;
    
    final basePath = 'lib/features/$name';
    
    if (useCleanArch) {
      await _createDirectoryStructure([
        '$basePath/data/datasources',
        '$basePath/data/models',
        '$basePath/data/repositories',
        '$basePath/domain/entities',
        '$basePath/domain/repositories',
        '$basePath/domain/usecases',
        '$basePath/presentation/cubit',
        '$basePath/presentation/screens',
        '$basePath/presentation/widgets',
      ]);
    } else {
      await _createDirectoryStructure([
        '$basePath/screens',
        '$basePath/widgets',
        '$basePath/services',
      ]);
    }

    // Crear archivos básicos
    await FileUtils.writeFile(
      '$basePath/presentation/screens/${name}_screen.dart',
      _generateBasicScreen(name),
    );

    if (includeCubit && useCleanArch) {
      await FileUtils.writeFile(
        '$basePath/presentation/cubit/${name}_cubit.dart',
        _generateBasicCubit(name),
      );
      
      await FileUtils.writeFile(
        '$basePath/presentation/cubit/${name}_state.dart',
        StateTemplates.generateGenericState(name),
      );
    }

    ConsoleUtils.success('✅ Feature $name generado exitosamente!');
    _showNextSteps('feature', name);
  }

  /// Genera carpeta shared completa con widgets y utilidades
  Future<void> generateSharedFolder(Map<String, dynamic> options) async {
    ConsoleUtils.info('🔧 Generando carpeta shared con implementaciones...');
    
    await _createDirectoryStructure([
      'lib/shared/widgets/buttons',
      'lib/shared/widgets/forms',
      'lib/shared/widgets/cards',
      'lib/shared/widgets/loading',
      'lib/shared/models',
      'lib/shared/utils/validators',
      'lib/shared/utils/formatters',
      'lib/shared/utils/datetime',
      'lib/shared/services',
    ]);

    // Generar widgets básicos
    await FileUtils.writeFile(
      'lib/shared/widgets/buttons/custom_button.dart',
      SharedTemplates.generateCustomButton(),
    );

    await FileUtils.writeFile(
      'lib/shared/widgets/forms/custom_text_field.dart',
      SharedTemplates.generateCustomTextField(),
    );

    await FileUtils.writeFile(
      'lib/shared/widgets/loading/loading_overlay.dart',
      SharedTemplates.generateLoadingOverlay(),
    );

    await FileUtils.writeFile(
      'lib/shared/widgets/cards/custom_card.dart',
      SharedTemplates.generateCustomCard(),
    );

    // Generar modelos
    await FileUtils.writeFile(
      'lib/shared/models/base_model.dart',
      SharedTemplates.generateBaseModel(),
    );

    await FileUtils.writeFile(
      'lib/shared/models/result.dart',
      SharedTemplates.generateResultPattern(),
    );

    // Generar utilidades
    await FileUtils.writeFile(
      'lib/shared/utils/validators/validator_utils.dart',
      SharedTemplates.generateValidatorUtils(),
    );

    await FileUtils.writeFile(
      'lib/shared/utils/formatters/format_utils.dart',
      SharedTemplates.generateFormatUtils(),
    );

    await FileUtils.writeFile(
      'lib/shared/utils/datetime/datetime_utils.dart',
      SharedTemplates.generateDateTimeUtils(),
    );

    ConsoleUtils.success('✅ Carpeta shared generada con implementaciones completas');
  }

  /// Genera configuración completa de core (database, network, storage)
  Future<void> generateCoreConfiguration(Map<String, dynamic> options) async {
    ConsoleUtils.info('🔧 Generando configuración core completa...');
    
    final databaseType = options['database-type'] ?? 'sqlite'; // sqlite, drift
    final includeNetwork = options['include-network'] ?? true;
    final includeStorage = options['include-storage'] ?? true;
    
    await _createDirectoryStructure([
      'lib/core/database',
      'lib/core/network',
      'lib/core/storage',
      'lib/core/services',
      'lib/core/repositories',
    ]);

    // Configuración de base de datos
    if (databaseType == 'sqlite') {
      await FileUtils.writeFile(
        'lib/core/database/database_config.dart',
        CoreTemplates.generateDatabaseConfig(),
      );
      
      await FileUtils.writeFile(
        'lib/core/repositories/base_repository.dart',
        CoreTemplates.generateBaseRepository(),
      );
      
      await FileUtils.writeFile(
        'lib/core/repositories/user_repository.dart',
        CoreTemplates.generateUserRepository(),
      );
    } else if (databaseType == 'drift') {
      await FileUtils.writeFile(
        'lib/core/database/app_database.dart',
        CoreTemplates.generateDriftDatabase(),
      );
    }

    // Configuración de red
    if (includeNetwork) {
      await FileUtils.writeFile(
        'lib/core/network/network_config.dart',
        CoreTemplates.generateNetworkConfig(),
      );
    }

    // Almacenamiento seguro
    if (includeStorage) {
      await FileUtils.writeFile(
        'lib/core/storage/secure_storage_service.dart',
        CoreTemplates.generateSecureStorageService(),
      );
    }

    ConsoleUtils.success('✅ Configuración core generada exitosamente');
  }

  /// Genera configuración completa de navegación
  Future<void> generateAppRouting(Map<String, dynamic> options) async {
    ConsoleUtils.info('🧭 Generando configuración de navegación...');
    
    final routingType = options['routing-type'] ?? 'go_router'; // go_router, auto_route
    
    await _createDirectoryStructure([
      'lib/core/routing',
    ]);

    if (routingType == 'go_router') {
      // Configuración con go_router
      await FileUtils.writeFile(
        'lib/core/routing/app_router.dart',
        RoutingTemplates.generateGoRouterConfig(),
      );
      
      // Main.dart con go_router
      await FileUtils.writeFile(
        'lib/main.dart',
        RoutingTemplates.generateMainWithRouting(),
      );
      
      // HomeScreen con navegación
      await FileUtils.writeFile(
        'lib/features/home/presentation/screens/home_screen.dart',
        RoutingTemplates.generateHomeScreenWithNavigation(),
      );
    }

    ConsoleUtils.success('✅ Configuración de navegación generada exitosamente');
    ConsoleUtils.info('📝 Recuerda ejecutar build_runner si usas auto_route:');
    ConsoleUtils.info('    dart run build_runner build');
  }

  /// Genera tema profesional completo
  Future<void> generateProfessionalTheme(Map<String, dynamic> options) async {
    ConsoleUtils.info('🎨 Generando tema profesional...');
    
    await _createDirectoryStructure([
      'lib/configs/theme',
    ]);

    // Generar tema principal
    await FileUtils.writeFile(
      'lib/configs/theme/app_theme.dart',
      ThemeTemplates.generateProfessionalTheme(),
    );
    
    // Generar configuración de tema
    await FileUtils.writeFile(
      'lib/configs/theme/theme_config.dart',
      ThemeTemplates.generateThemeConfig(),
    );
    
    // Generar componentes profesionales
    await FileUtils.writeFile(
      'lib/shared/widgets/professional_components.dart',
      ThemeTemplates.generateProfessionalComponents(),
    );

    ConsoleUtils.success('✅ Tema profesional generado exitosamente');
  }

  /// Genera aplicación funcional completa
  Future<void> generateWorkingFullApp(String appName, Map<String, dynamic> options) async {
    ConsoleUtils.info('🚀 Generando aplicación funcional completa: $appName');
    
    // 1. Generar pubspec.yaml con dependencias esenciales
    await _generateWorkingPubspec(appName, options);
    
    // 2. Generar estructura básica funcional
    await _setupWorkingProjectStructure();
    
    // 3. Generar archivos core funcionales
    await _generateWorkingCore(appName);
    
    // 4. Generar pantallas funcionales
    await _generateWorkingScreens();
    
    // 5. Generar shared widgets funcionales
    await _generateWorkingShared();
    
    ConsoleUtils.success('✅ Aplicación funcional generada exitosamente!');
    ConsoleUtils.info('');
    ConsoleUtils.info('📱 Tu app $appName está lista y funcional:');
    ConsoleUtils.info('  ✓ Estructura de proyecto completa');
    ConsoleUtils.info('  ✓ Pantallas de Login y Home funcionales');
    ConsoleUtils.info('  ✓ SplashScreen con animaciones');
    ConsoleUtils.info('  ✓ Sistema de navegación');
    ConsoleUtils.info('  ✓ Almacenamiento seguro configurado');
    ConsoleUtils.info('  ✓ Tema Material Design configurado');
    ConsoleUtils.info('  ✓ Formularios y validaciones');
    ConsoleUtils.info('  ✓ Gestión de estado HTTP');
    ConsoleUtils.info('');
    ConsoleUtils.info('🚀 Para comenzar, ejecuta:');
    ConsoleUtils.info('    cd $appName');
    ConsoleUtils.info('    flutter pub get');
    ConsoleUtils.info('    flutter run');
  }

  /// Genera pubspec.yaml funcional
  Future<void> _generateWorkingPubspec(String appName, Map<String, dynamic> options) async {
    final pubspecContent = '''
name: ${appName.toLowerCase().replaceAll(' ', '_')}
description: A Flutter application generated with professional structure.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.13.0"

dependencies:
  flutter:
    sdk: flutter
  
  # UI
  cupertino_icons: ^1.0.6
  
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # Network
  http: ^1.1.0
  connectivity_plus: ^4.0.2
  internet_connection_checker: ^1.0.0+1
  
  # Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.2
  
  # Utils
  intl: ^0.18.1
  
  # Environment
  envied: ^0.3.0+3
  
  # Localization
  flutter_localizations:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  envied_generator: ^0.3.0+3
  build_runner: ^2.4.7

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
  
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
        - asset: assets/fonts/Roboto-Bold.ttf
          weight: 700
''';

    await FileUtils.writeFile('pubspec.yaml', pubspecContent);
    
    // Crear archivo .env
    await FileUtils.writeFile('.env', '''
API_URL=https://api.example.com
APP_NAME=$appName
DEBUG=true
PORT=3000
TOKEN=

# Configuracion de la base de datos PostgreSQL EXAMPLE
DB_HOST= 192---tuIP
DB_PORT= 5432
DB_USER= postgres
DB_PASS= 123456

# Clave Secreta para JWT

JWT_SECRET= tu_secreto_super_seguro
JWT_EXPIRES_IN=

API_PERSONA_URL= TU API ACA

#MAIL CONFIGURATION

SMTP_HOST=
SMTP_PORT=
SMTP_SECURE=
SMTP_PASS= 
SMTP_FROM=
''');
  }

  /// Configura estructura de proyecto funcional
  Future<void> _setupWorkingProjectStructure() async {
    await _createDirectoryStructure([
      'lib/configs/constants',
      'lib/configs/theme',
      'lib/controllers',
      'lib/screen/auth',
      'lib/screen/home/modules',
      'lib/screen/splash',
      'lib/shared/common',
      'lib/shared/widgets/forms',
      'lib/shared/widgets',
      'assets/images',
      'assets/icons',
      'assets/fonts',
    ]);
  }

  /// Genera archivos core funcionales
  Future<void> _generateWorkingCore(String appName) async {
    // Main.dart
    await FileUtils.writeFile(
      'lib/main.dart',
      WorkingTemplates.generateWorkingMain(appName),
    );
    
    // Config
    await FileUtils.writeFile(
      'lib/configs/config.dart',
      WorkingTemplates.generateConfig(),
    );
    
    await FileUtils.writeFile(
      'lib/configs/constants/env.dart',
      WorkingTemplates.generateEnv(),
    );
    
    await FileUtils.writeFile(
      'lib/configs/constants/secure_storage.dart',
      WorkingTemplates.generateSecureStorage(),
    );
    
    // Theme
    await FileUtils.writeFile(
      'lib/configs/theme/app_theme.dart',
      _generateSimpleTheme(),
    );
    
    // Controllers
    await FileUtils.writeFile(
      'lib/controllers/users.dart',
      WorkingTemplates.generateUsersController(),
    );
  }

  /// Genera pantallas funcionales
  Future<void> _generateWorkingScreens() async {
    // Splash Screen
    await FileUtils.writeFile(
      'lib/screen/splash/splash_screen.dart',
      WorkingTemplates.generateSplashScreen(),
    );
    
    // Login Screen
    await FileUtils.writeFile(
      'lib/screen/auth/login_screen.dart',
      WorkingTemplates.generateLoginScreen(),
    );
    
    // Home Screen
    await FileUtils.writeFile(
      'lib/screen/home/home_screen.dart',
      WorkingTemplates.generateHomeScreen(),
    );
    
    // Home modules
    await FileUtils.writeFile(
      'lib/screen/home/modules/home_section.dart',
      _generateHomeSection(),
    );
    
    await FileUtils.writeFile(
      'lib/screen/home/modules/profile_section.dart',
      _generateProfileSection(),
    );
  }

  /// Genera shared widgets funcionales
  Future<void> _generateWorkingShared() async {
    // Common
    await FileUtils.writeFile(
      'lib/shared/common/common.dart',
      WorkingTemplates.generateCommon(),
    );
    
    await FileUtils.writeFile(
      'lib/shared/common/check_internet.dart',
      WorkingTemplates.generateCheckInternet(),
    );
    
    await FileUtils.writeFile(
      'lib/shared/common/data_user.dart',
      WorkingTemplates.generateDataUser(),
    );
    
    await FileUtils.writeFile(
      'lib/shared/common/helper.dart',
      WorkingTemplates.generateHelper(),
    );
    
    // Widgets
    await FileUtils.writeFile(
      'lib/shared/widgets/forms/label_text_form_field.dart',
      WorkingTemplates.generateLabelTextFormField(),
    );
    
    await FileUtils.writeFile(
      'lib/shared/widgets/side_menu.dart',
      _generateSideMenu(),
    );
  }

  /// Genera tema simple funcional
  String _generateSimpleTheme() {
    return '''
import 'package:flutter/material.dart';

class AppTheme {
  static ButtonThemeData buttonTheme = ButtonThemeData(
    buttonColor: Colors.blue,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      primaryColorLight: Colors.blue[200],
      colorScheme: ColorScheme.light(
          primary: Colors.blue, primaryContainer: Colors.blue[200]),
      cardTheme: CardThemeData(color: Colors.blue[200]),
      scaffoldBackgroundColor: Colors.white,
      buttonTheme: buttonTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
      ));

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    primaryColorDark: Colors.blue[700],
    scaffoldBackgroundColor: Colors.black87,
    colorScheme: ColorScheme.dark(
        primary: Colors.blue, primaryContainer: Colors.blue[700]),
    cardTheme: CardThemeData(color: Colors.blue[700]),
    buttonTheme: buttonTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    ),
  );
}
''';
  }

  String _generateHomeSection() {
    return '''
import 'package:flutter/material.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenido',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          
          // Cards de acceso rápido
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildFeatureCard(
                context,
                'Perfil',
                Icons.person,
                Colors.blue,
                () {},
              ),
              _buildFeatureCard(
                context,
                'Configuración',
                Icons.settings,
                Colors.green,
                () {},
              ),
              _buildFeatureCard(
                context,
                'Notificaciones',
                Icons.notifications,
                Colors.orange,
                () {},
              ),
              _buildFeatureCard(
                context,
                'Ayuda',
                Icons.help,
                Colors.purple,
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
''';
  }

  String _generateProfileSection() {
    return '''
import 'package:flutter/material.dart';
import '../../../configs/constants/secure_storage.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  
  Future<void> _logout() async {
    await deleteAll();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60,
            child: Icon(Icons.person, size: 60),
          ),
          const SizedBox(height: 20),
          
          Text(
            'Usuario',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          
          const SizedBox(height: 40),
          
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mi Perfil'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ayuda'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          
          const Spacer(),
          
          ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar Sesión'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
''';
  }

  String _generateSideMenu() {
    return '''
import 'package:flutter/material.dart';
import '../../configs/constants/secure_storage.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                SizedBox(height: 10),
                Text(
                  'Usuario',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          
          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await deleteAll();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
''';
  }

  /// Genera componentes neumórficos
  Future<void> generateNeumorphicComponents(Map<String, dynamic> options) async {
    ConsoleUtils.info('Generando componentes neumórficos...');
    
    await _createDirectoryStructure([
      'lib/shared/widgets/neumorphic',
      'lib/shared/theme/neumorphic',
      'lib/shared/utils/neumorphic',
    ]);

    // Tema neumórfico
    await FileUtils.writeFile(
      'lib/shared/theme/neumorphic/neumorphic_theme.dart',
      NeumorphicComponentsTemplates.generateNeumorphicTheme(),
    );
    
    // Componentes básicos
    await FileUtils.writeFile(
      'lib/shared/widgets/neumorphic/neumorphic_button.dart',
      NeumorphicComponentsTemplates.generateNeumorphicButton(),
    );
    
    await FileUtils.writeFile(
      'lib/shared/widgets/neumorphic/neumorphic_container.dart',
      NeumorphicComponentsTemplates.generateNeumorphicContainer(),
    );
    
    await FileUtils.writeFile(
      'lib/shared/widgets/neumorphic/neumorphic_text_field.dart',
      NeumorphicComponentsTemplates.generateNeumorphicTextField(),
    );
    
    // Comentamos los componentes que no están implementados aún
    // await FileUtils.writeFile(
    //   'lib/shared/widgets/neumorphic/neumorphic_slider.dart',
    //   NeumorphicComponentsTemplates.generateNeumorphicSlider(),
    // );
    
    // await FileUtils.writeFile(
    //   'lib/shared/widgets/neumorphic/neumorphic_switch.dart',
    //   NeumorphicComponentsTemplates.generateNeumorphicSwitch(),
    // );
    
    // await FileUtils.writeFile(
    //   'lib/shared/widgets/neumorphic/neumorphic_progress.dart',
    //   NeumorphicComponentsTemplates.generateNeumorphicProgress(),
    // );
    
    // Sistema de comandos
    await FileUtils.writeFile(
      'lib/shared/utils/neumorphic/component_inserter.dart',
      NeumorphicComponentsTemplates.generateCommandSystem(),
    );

    ConsoleUtils.success('Componentes neumórficos generados exitosamente!');
    ConsoleUtils.info(' Componentes disponibles:');
    ConsoleUtils.info('  • NeumorphicButton - Botones con efectos táctiles y variantes (.text, .icon, .iconText)');
    ConsoleUtils.info('  • NeumorphicContainer - Contenedores con sombras (flat, concave, convex)');
    ConsoleUtils.info('  • NeumorphicTextField - Campos de texto con animaciones de foco');
    ConsoleUtils.info('  • NeumorphicTheme - Sistema de temas con modo claro/oscuro automático');
    ConsoleUtils.info('  • ComponentInserter - Sistema de análisis inteligente de código');
    ConsoleUtils.info('  • NeumorphicCLI - Comandos para generar código automáticamente');
    ConsoleUtils.info('');
    ConsoleUtils.info(' Ejemplos de uso:');
    ConsoleUtils.info('  // Botón básico');
    ConsoleUtils.info('  NeumorphicButton.text(');
    ConsoleUtils.info('    text: "Mi Botón",');
    ConsoleUtils.info('    onPressed: () {},');
    ConsoleUtils.info('    style: NeumorphicTheme.styleFor(context),');
    ConsoleUtils.info('  )');
    ConsoleUtils.info('');
    ConsoleUtils.info('  // Campo de texto');
    ConsoleUtils.info('  NeumorphicTextField(');
    ConsoleUtils.info('    hintText: "Ingresa tu texto",');
    ConsoleUtils.info('    labelText: "Campo",');
    ConsoleUtils.info('    style: NeumorphicTheme.styleFor(context),');
    ConsoleUtils.info('  )');
    ConsoleUtils.info('');
    ConsoleUtils.info('  Comandos CLI disponibles:');
    ConsoleUtils.info('  NeumorphicCLI.handleCommand(["create", "button", "--text"])');
    ConsoleUtils.info('  NeumorphicCLI.handleCommand(["analyze", "lib/main.dart"])');
    ConsoleUtils.info('  NeumorphicCLI.handleCommand(["list"])'); // Muestra todos los componentes
  }
  
  /// Genera componentes adicionales mejorados
  Future<void> generateEnhancedComponents(Map<String, dynamic> options) async {
    ConsoleUtils.info('Generando componentes adicionales mejorados...');
    
    await _createDirectoryStructure([
      'lib/shared/widgets/enhanced',
      'lib/shared/widgets/forms',
      'lib/shared/widgets/buttons',
      'lib/shared/widgets/cards',
    ]);

    // Componentes de tarjeta animada
    await FileUtils.writeFile(
      'lib/shared/widgets/cards/animated_card.dart',
      AdditionalComponentsTemplates.generateAnimatedCard(),
    );
    
    // Componentes de formulario mejorados
    await FileUtils.writeFile(
      'lib/shared/widgets/forms/enhanced_text_fields.dart',
      AdditionalComponentsTemplates.generateEnhancedFormComponents(),
    );
    
    // Botones mejorados
    await FileUtils.writeFile(
      'lib/shared/widgets/buttons/enhanced_buttons.dart',
      AdditionalComponentsTemplates.generateEnhancedButtonComponents(),
    );

    ConsoleUtils.success('Componentes adicionales generados exitosamente!');
    ConsoleUtils.info(' Nuevos componentes:');
    ConsoleUtils.info('  • AnimatedCard - Tarjetas con animaciones');
    ConsoleUtils.info('  • EmailTextField - Campo de email especializado');
    ConsoleUtils.info('  • PasswordTextField - Campo con validación de contraseña');
    ConsoleUtils.info('  • PhoneTextField - Campo para teléfonos');
    ConsoleUtils.info('  • CustomButton - Botones altamente configurables');
    ConsoleUtils.info('  • CustomFloatingActionButton - FAB mejorado');
  }
  
  /// Genera aplicación completa mejorada (versión original mantenida para compatibilidad)
  Future<void> generateFullApp(String appName, Map<String, dynamic> options) async {
    // Usar la versión funcional por defecto
    await generateWorkingFullApp(appName, options);
  }
  
  /// Genera aplicación completa con componentes neumórficos incluidos
  Future<void> generateFullAppWithNeumorphic(String appName, Map<String, dynamic> options) async {
    ConsoleUtils.info('Generando aplicación completa con componentes neumórficos...');
    
    // Generar aplicación base
    await generateWorkingFullApp(appName, options);
    
    // Agregar componentes neumórficos
    await generateNeumorphicComponents(options);
    
    // Agregar componentes adicionales
    await generateEnhancedComponents(options);
    
    ConsoleUtils.success('Aplicación completa con componentes neumórficos generada exitosamente!');
    ConsoleUtils.info('');
    ConsoleUtils.info('---1)  Tu aplicación incluye:');
    ConsoleUtils.info(' 1.- Aplicación Flutter funcional completa');
    ConsoleUtils.info(' 2.- Componentes neumórficos modernos');
    ConsoleUtils.info(' 3.- Sistema de análisis inteligente de código');
    ConsoleUtils.info(' 4.- CLI para generar código automáticamente');
    ConsoleUtils.info(' 5.- Pantallas responsive mejoradas');
    ConsoleUtils.info(' 6.- Formularios con validación avanzada');
    ConsoleUtils.info('');
    ConsoleUtils.info('--- 2) Comienza a usar componentes neumórficos:');
    ConsoleUtils.info('  import "lib/shared/theme/neumorphic/neumorphic_theme.dart";');
    ConsoleUtils.info('  import "lib/shared/widgets/neumorphic/neumorphic_button.dart";');
    ConsoleUtils.info('');
    ConsoleUtils.info('--- 3) Usa el CLI para análisis inteligente:');
    ConsoleUtils.info('  // En tu código Dart:');
    ConsoleUtils.info('  NeumorphicCLI.handleCommand(["analyze", "lib/main.dart"]);');
  }

  /// Inicializa el proyecto
  Future<void> initializeProject() async {
    ConsoleUtils.info('Inicializando proyecto...');
    
    await setupMason();
    await setupDependencies();
    await setupProjectStructure();
    
    ConsoleUtils.success(' Proyecto inicializado exitosamente!');
  }

  /// Configura Mason CLI
  Future<void> setupMason() async {
    ConsoleUtils.info('Configurando Mason CLI...');
    
    try {
      final result = await Process.run('dart', ['pub', 'global', 'activate', 'mason_cli']);
      if (result.exitCode == 0) {
        ConsoleUtils.success(' Mason CLI instalado exitosamente');
      } else {
        throw Exception('Error instalando Mason CLI: ${result.stderr}');
      }
      
      // Inicializar Mason en el proyecto
      final initResult = await Process.run('mason', ['init'], workingDirectory: Directory.current.path);
      if (initResult.exitCode == 0) {
        ConsoleUtils.success('Mason inicializado en el proyecto');
      }
    } catch (e) {
      ConsoleUtils.warning(' Error configurando Mason: $e');
      ConsoleUtils.info('Instala Mason manualmente: dart pub global activate mason_cli');
    }
  }

  /// Instala dependencias
  Future<void> setupDependencies() async {
    ConsoleUtils.info(' Instalando dependencias...');
    
    final dependencies = [
      'flutter_bloc',
      'dio',
      'flutter_secure_storage',
      'connectivity_plus',
      'shared_preferences',
      'cached_network_image',
      'image_picker',
      'permission_handler',
    ];

    final devDependencies = [
      'build_runner',
      'json_annotation',
      'json_serializable',
    ];

    try {
      for (String dep in dependencies) {
        ConsoleUtils.info(' Añadiendo $dep...');
        await Process.run('flutter', ['pub', 'add', dep]);
      }
      
      for (String dep in devDependencies) {
        ConsoleUtils.info(' Añadiendo $dep (dev)...');
        await Process.run('flutter', ['pub', 'add', 'dev:$dep']);
      }
      
      ConsoleUtils.success(' Dependencias instaladas exitosamente');
    } catch (e) {
      ConsoleUtils.error(' Error instalando dependencias: $e');
    }
  }

  /// Crea estructura de carpetas del proyecto
  Future<void> setupProjectStructure() async {
    ConsoleUtils.info('Creando estructura del proyecto...');
    
    await _createDirectoryStructure([
      'lib/core/theme',
      'lib/core/network',
      'lib/core/database',
      'lib/core/storage',
      'lib/core/constants',
      'lib/core/utils',
      'lib/shared/widgets',
      'lib/shared/services',
      'lib/shared/animations',
      'lib/features',
      'assets/images',
      'assets/icons',
      'assets/fonts',
      'test/unit',
      'test/widget',
      'test/integration',
    ]);

    // Crear archivos básicos
    await FileUtils.writeFile(
      'lib/core/theme/app_theme.dart',
      _generateAppTheme(),
    );
    
    await FileUtils.writeFile(
      'lib/core/constants/app_constants.dart',
      _generateAppConstants(),
    );

    ConsoleUtils.success('Estructura del proyecto creada');
  }

  // Métodos auxiliares privados
  
  Future<void> _createDirectoryStructure(List<String> paths) async {
    for (String path in paths) {
      final directory = Directory(path);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
        ConsoleUtils.info('Creado: $path');
      }
    }
  }

  void _showNextSteps(String type, String name) {
    ConsoleUtils.info('');
    ConsoleUtils.info('PRÓXIMOS PASOS:');
    
    switch (type) {
      case 'auth':
        ConsoleUtils.info('1. Configura las rutas en tu main.dart');
        ConsoleUtils.info('2. Añade el AuthCubit a tu BlocProvider');
        ConsoleUtils.info('3. Implementa la lógica de autenticación en los repositorios');
        break;
      case 'splash':
        ConsoleUtils.info('1. Configura el SplashScreen como pantalla inicial');
        ConsoleUtils.info('2. Añade tu logo en assets/images/logo.png');
        ConsoleUtils.info('3. Implementa la lógica de inicialización');
        break;
      case 'home':
        ConsoleUtils.info('1. Configura las rutas de navegación');
        ConsoleUtils.info('2. Personaliza las secciones según tu app');
        ConsoleUtils.info('3. Implementa el sistema de notificaciones');
        break;
      case 'api':
        ConsoleUtils.info('1. Configura la URL base de tu API');
        ConsoleUtils.info('2. Implementa los endpoints específicos');
        ConsoleUtils.info('3. Configura los interceptors de autenticación');
        break;
    }
    ConsoleUtils.info('');
  }

  String _generateBasicScreen(String name) {
    return '''
import 'package:flutter/material.dart';

class ${_pascalCase(name)}Screen extends StatefulWidget {
  const ${_pascalCase(name)}Screen({super.key});

  @override
  State<${_pascalCase(name)}Screen> createState() => _${_pascalCase(name)}ScreenState();
}

class _${_pascalCase(name)}ScreenState extends State<${_pascalCase(name)}Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_capitalize(name)}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_capitalize(name)} Screen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            Text(
              'Implementa aquí tu lógica personalizada',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
''';
  }

  String _generateOnboardingCubit(String name) {
    return '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  void nextPage(int currentPage, int totalPages) {
    if (currentPage < totalPages - 1) {
      emit(OnboardingPageChanged(currentPage + 1));
    } else {
      completeOnboarding();
    }
  }

  void previousPage(int currentPage) {
    if (currentPage > 0) {
      emit(OnboardingPageChanged(currentPage - 1));
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  Future<void> completeOnboarding() async {
    emit(OnboardingLoading());
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
      
      emit(OnboardingCompleted());
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  void goToPage(int page) {
    emit(OnboardingPageChanged(page));
  }
}
''';
  }

  String _generateBasicCubit(String name) {
    return '''
import 'package:flutter_bloc/flutter_bloc.dart';

part '${name}_state.dart';

class ${_pascalCase(name)}Cubit extends Cubit<${_pascalCase(name)}State> {
  ${_pascalCase(name)}Cubit() : super(${_pascalCase(name)}Initial());

  void loadData() {
    emit(${_pascalCase(name)}Loading());
    // Implementar lógica de carga
    // emit(${_pascalCase(name)}Success(data));
  }
}
''';
  }

  String _generateAppTheme() {
    return '''
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      fontFamily: 'Roboto',
    );
  }
}
''';
  }

  String _generateAppConstants() {
    return '''
class AppConstants {
  static const String appName = 'My App';
  static const String appVersion = '1.0.0';
  
  // API
  static const String baseUrl = 'https://api.example.com';
  static const int connectionTimeout = 30000;
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  
  // Routes
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
}
''';
  }

  String _pascalCase(String text) {
    return text.split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join('');
  }

  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }
  
  /// Valida que todos los templates estén disponibles
  
  /// Muestra información del generador
  void showGeneratorInfo() {
    ConsoleUtils.info(' Flutter App Base Generator v2.0');
    ConsoleUtils.info('================================================');
    ConsoleUtils.info(' Características disponibles:');
    ConsoleUtils.info('  • Generación de apps funcionales completas');
    ConsoleUtils.info('  • Pantallas responsive para todos los dispositivos');
    ConsoleUtils.info('  • Componentes neumórficos modernos');
    ConsoleUtils.info('  • Sistema de análisis inteligente de código');
    ConsoleUtils.info('  • CLI para automatización');
    ConsoleUtils.info('  • Clean Architecture opcional');
    ConsoleUtils.info('  • Formularios con validación avanzada');
    ConsoleUtils.info('  • Temas profesionales');
    ConsoleUtils.info('  • Navegación configurada');
    ConsoleUtils.info('  • Almacenamiento seguro');
    ConsoleUtils.info('');
    ConsoleUtils.info(' Comandos principales:');
    ConsoleUtils.info('  generateFullApp() - App estándar');
    ConsoleUtils.info('  generateFullAppWithNeumorphic() - App con componentes neumórficos');
    ConsoleUtils.info('  generateAuth() - Feature de autenticación');
    ConsoleUtils.info('  generateNeumorphicComponents() - Solo componentes neumórficos');
    ConsoleUtils.info('  generateEnhancedComponents() - Componentes adicionales');
  }
}
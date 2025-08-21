import 'dart:io';
import 'file_utils.dart';
import 'console_utils.dart';

class PubspecManager {
  
  /// Genera un pubspec.yaml funcional simple
  static Future<void> generatePubspec({
    required String projectName,
    required String description,
    String? version,
    List<String>? additionalDependencies,
    List<String>? additionalDevDependencies,
    Map<String, dynamic>? options,
  }) async {
    ConsoleUtils.info('📝 Generando pubspec.yaml para $projectName...');
    
    final pubspecContent = _buildSimplePubspec(projectName, description, version ?? '1.0.0+1');

    await FileUtils.writeFile('pubspec.yaml', pubspecContent);
    ConsoleUtils.success('✅ pubspec.yaml generado exitosamente');
  }

  /// Instala dependencias automáticamente
  static Future<void> installDependencies() async {
    ConsoleUtils.info('📦 Instalando dependencias...');
    
    try {
      final result = await Process.run(
        'flutter',
        ['pub', 'get'],
        workingDirectory: Directory.current.path,
      );
      
      if (result.exitCode == 0) {
        ConsoleUtils.success('✅ Dependencias instaladas exitosamente');
      } else {
        ConsoleUtils.error('❌ Error instalando dependencias: ${result.stderr}');
      }
    } catch (e) {
      ConsoleUtils.error('❌ Error ejecutando flutter pub get: $e');
    }
  }

  /// Ejecuta build_runner para generar código
  static Future<void> runBuildRunner() async {
    ConsoleUtils.info('🔨 Ejecutando build_runner...');
    
    try {
      final result = await Process.run(
        'dart',
        ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
        workingDirectory: Directory.current.path,
      );
      
      if (result.exitCode == 0) {
        ConsoleUtils.success('✅ Build runner ejecutado exitosamente');
      } else {
        ConsoleUtils.warning('⚠️ Build runner terminó con advertencias: ${result.stderr}');
      }
    } catch (e) {
      ConsoleUtils.error('❌ Error ejecutando build_runner: $e');
    }
  }

  /// Construye un pubspec.yaml simple y funcional
  static String _buildSimplePubspec(String projectName, String description, String version) {
    return '''
name: $projectName
description: $description
publish_to: 'none'
version: $version

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
  
  # Navigation (opcional)
  go_router: ^12.1.3
  
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
  }
}
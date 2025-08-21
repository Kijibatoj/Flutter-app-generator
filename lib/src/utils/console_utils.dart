import 'dart:io';

class ConsoleUtils {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';
  // static const String _white = '\x1B[37m'; // Reserved for future use
  static const String _bold = '\x1B[1m';

  /// Imprime mensaje de información en azul
  static void info(String message) {
    stdout.writeln('$_blue$message$_reset');
  }

  /// Imprime mensaje de éxito en verde
  static void success(String message) {
    stdout.writeln('$_green$message$_reset');
  }

  /// Imprime mensaje de advertencia en amarillo
  static void warning(String message) {
    stdout.writeln('$_yellow$message$_reset');
  }

  /// Imprime mensaje de error en rojo
  static void error(String message) {
    stderr.writeln('$_red$message$_reset');
  }

  /// Imprime título en magenta y negrita
  static void title(String message) {
    stdout.writeln('$_bold$_magenta$message$_reset');
  }

  /// Imprime subtítulo en cian
  static void subtitle(String message) {
    stdout.writeln('$_cyan$message$_reset');
  }

  /// Imprime mensaje simple sin colores
  static void plain(String message) {
    stdout.writeln(message);
  }

  /// Imprime separador
  static void separator() {
    stdout.writeln('$_cyan${'=' * 50}$_reset');
  }

  /// Imprime línea vacía
  static void newLine() {
    stdout.writeln('');
  }

  /// Pregunta al usuario con opciones sí/no
  static Future<bool> askYesNo(String question, {bool defaultValue = false}) async {
    final defaultText = defaultValue ? 'Y/n' : 'y/N';
    stdout.write('$_yellow$question [$defaultText]: $_reset');
    
    final input = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    
    if (input.isEmpty) return defaultValue;
    return input.startsWith('y') || input.startsWith('s');
  }

  /// Pregunta al usuario por texto
  static Future<String> askText(String question, {String? defaultValue}) async {
    final defaultText = defaultValue != null ? ' [$defaultValue]' : '';
    stdout.write('$_yellow$question$defaultText: $_reset');
    
    final input = stdin.readLineSync()?.trim() ?? '';
    return input.isEmpty && defaultValue != null ? defaultValue : input;
  }

  /// Muestra una lista de opciones y pide selección
  static Future<int> askChoice(String question, List<String> options) async {
    stdout.writeln('$_yellow$question$_reset');
    
    for (int i = 0; i < options.length; i++) {
      stdout.writeln('  ${i + 1}. ${options[i]}');
    }
    
    while (true) {
      stdout.write('${_yellow}Selecciona una opción (1-${options.length}): $_reset');
      final input = stdin.readLineSync()?.trim() ?? '';
      final choice = int.tryParse(input);
      
      if (choice != null && choice >= 1 && choice <= options.length) {
        return choice - 1;
      }
      
      error('❌ Opción inválida. Intenta de nuevo.');
    }
  }

  /// Muestra barra de progreso simple
  static void showProgress(String task, double progress) {
    final barLength = 30;
    final filledLength = (progress * barLength).round();
    final bar = '█' * filledLength + '░' * (barLength - filledLength);
    final percentage = (progress * 100).toStringAsFixed(1);
    
    stdout.write('\r$_cyan$task: [$bar] $percentage%$_reset');
    
    if (progress >= 1.0) {
      stdout.writeln('');
    }
  }

  /// Limpia la consola
  static void clear() {
    if (Platform.isWindows) {
      Process.runSync('cls', [], runInShell: true);
    } else {
      Process.runSync('clear', [], runInShell: true);
    }
  }

  /// Imprime banner de la aplicación
  static void showBanner() {
    clear();
    title('''
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║    🚀 APP BASE GENERATOR - Flutter Mobile App Generator       ║
║                                                               ║
║    📱 Genera aplicaciones móviles completas con:             ║
║    • Autenticación (Login, Registro, Recovery)               ║
║    • SplashScreen con animaciones                             ║
║    • Onboarding interactivo                                   ║
║    • HomeScreen con navegación                                ║
║    • Configuración de API y Base de datos                    ║
║    • Arquitectura limpia y escalable                         ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
''');
    newLine();
  }

  /// Imprime información del sistema
  static void showSystemInfo() {
    info('🖥️  Sistema: ${Platform.operatingSystem}');
    info('📂 Directorio actual: ${Directory.current.path}');
    info('⚡ Dart SDK: ${Platform.version}');
    newLine();
  }
}
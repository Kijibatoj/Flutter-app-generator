import 'dart:io';
import 'package:args/args.dart';
import 'generators/app_generator.dart';
import 'utils/console_utils.dart';
import 'models/generator_options.dart';

/// Main class for the Flutter App Base Generator
class FlutterAppBaseGenerator {
  late final ArgParser _parser;
  late final AppGenerator _appGenerator;

  FlutterAppBaseGenerator() {
    _appGenerator = AppGenerator();
    _setupArgParser();
  }

  /// Run the generator with command line arguments
  Future<void> run(List<String> arguments) async {
    try {
      if (arguments.isEmpty) {
        _showHelp();
        return;
      }

      final command = arguments[0];
      final args = arguments.skip(1).toList();

      switch (command) {
        case 'generate':
        case 'g':
          await _handleGenerate(args);
          break;
        case 'init':
          await _handleInit(args);
          break;
        case 'setup':
          await _handleSetup(args);
          break;
        case 'help':
        case '-h':
        case '--help':
          _showHelp();
          break;
        case 'version':
        case '-v':
        case '--version':
          _showVersion();
          break;
        default:
          ConsoleUtils.error('Unknown command: $command');
          _showHelp();
          exit(1);
      }
    } catch (e) {
      ConsoleUtils.error('Error: $e');
      exit(1);
    }
  }

  void _setupArgParser() {
    _parser = ArgParser()
      ..addFlag('help', 
          abbr: 'h', 
          negatable: false, 
          help: 'Show usage information')
      ..addFlag('version', 
          abbr: 'v', 
          negatable: false, 
          help: 'Show version information')
      ..addFlag('clean-architecture', 
          defaultsTo: true, 
          help: 'Use clean architecture pattern')
      ..addFlag('include-animations', 
          defaultsTo: true, 
          help: 'Include animations in components')
      ..addFlag('include-recovery', 
          defaultsTo: true, 
          help: 'Include password recovery functionality')
      ..addFlag('include-notifications', 
          defaultsTo: true, 
          help: 'Include notifications system')
      ..addFlag('use-dio', 
          defaultsTo: true, 
          help: 'Use Dio for HTTP requests')
      ..addFlag('include-interceptors', 
          defaultsTo: true, 
          help: 'Include HTTP interceptors')
      ..addFlag('include-secure-storage', 
          defaultsTo: true, 
          help: 'Include secure storage for tokens')
      ..addFlag('include-connectivity', 
          defaultsTo: true, 
          help: 'Include connectivity checking')
      ..addOption('navigation-type', 
          allowed: ['bottom', 'sidebar', 'both'], 
          defaultsTo: 'bottom',
          help: 'Type of navigation for home screen')
      ..addOption('tabs-count', 
          defaultsTo: '3', 
          help: 'Number of tabs in navigation')
      ..addOption('pages-count', 
          defaultsTo: '3', 
          help: 'Number of onboarding pages')
      ..addOption('animation-duration', 
          defaultsTo: '3', 
          help: 'Animation duration in seconds')
      ..addOption('base-url', 
          defaultsTo: 'https://api.example.com', 
          help: 'Base URL for API configuration');
  }

  Future<void> _handleGenerate(List<String> args) async {
    if (args.isEmpty) {
      ConsoleUtils.error('Specify what to generate: auth, splash, onboarding, home, api, feature, full-app');
      _showGenerateHelp();
      return;
    }

    final type = args[0];
    final name = args.length > 1 ? args[1] : null;
    
    // Parse remaining arguments
    final remainingArgs = args.skip(name != null ? 2 : 1).toList();
    final results = _parser.parse(remainingArgs);
    final options = GeneratorOptions.fromArgResults(results);

    switch (type) {
      case 'auth':
        await _appGenerator.generateAuth(name ?? 'auth', options.toMap());
        break;
      case 'splash':
        await _appGenerator.generateSplash(name ?? 'splash', options.toMap());
        break;
      case 'onboarding':
        await _appGenerator.generateOnboarding(name ?? 'onboarding', options.toMap());
        break;
      case 'home':
        await _appGenerator.generateHome(name ?? 'home', options.toMap());
        break;
      case 'api':
        await _appGenerator.generateApiConnection(name ?? 'api_service', options.toMap());
        break;
      case 'feature':
        if (name == null) {
          ConsoleUtils.error('Feature name is required');
          return;
        }
        await _appGenerator.generateFeature(name, options.toMap());
        break;
      case 'full-app':
        await _appGenerator.generateFullApp(name ?? 'MyApp', options.toMap());
        break;
      default:
        ConsoleUtils.error('Unknown generation type: $type');
        _showGenerateHelp();
    }
  }

  Future<void> _handleInit(List<String> args) async {
    await _appGenerator.initializeProject();
  }

  Future<void> _handleSetup(List<String> args) async {
    if (args.isEmpty) {
      ConsoleUtils.error('Specify what to setup: mason, dependencies, structure');
      return;
    }

    final setupType = args[0];

    switch (setupType) {
      case 'mason':
        await _appGenerator.setupMason();
        break;
      case 'dependencies':
        await _appGenerator.setupDependencies();
        break;
      case 'structure':
        await _appGenerator.setupProjectStructure();
        break;
      default:
        ConsoleUtils.error('Unknown setup type: $setupType');
    }
  }

  void _showHelp() {
    ConsoleUtils.showBanner();
    ConsoleUtils.info('''
📖 USAGE:
  flutter_app_gen [COMMAND] [OPTIONS]

🔧 COMMANDS:
  generate (g)    Generate app components
  init           Initialize new project
  setup          Setup tools and dependencies
  help           Show this help message
  version        Show version information

📱 GENERATE OPTIONS:
  auth [name]           Generate authentication feature
  splash [name]         Generate splash screen
  onboarding [name]     Generate onboarding flow
  home [name]           Generate home screen with navigation
  api [name]            Generate API configuration
  feature <name>        Generate custom feature
  full-app [name]       Generate complete application

💡 EXAMPLES:
  flutter_app_gen generate full-app MyAwesomeApp
  flutter_app_gen generate auth --clean-architecture
  flutter_app_gen generate home --navigation-type=bottom --tabs-count=4
  flutter_app_gen init
  flutter_app_gen setup dependencies

📚 For detailed documentation visit:
  https://github.com/ks2-projects/flutter_app_base_generator
''');
  }

  void _showGenerateHelp() {
    ConsoleUtils.info('''
📱 GENERATE COMMAND USAGE:
  flutter_app_gen generate <type> [name] [options]

🎯 AVAILABLE TYPES:
  auth              Authentication with login, register, recovery
  splash            Splash screen with animations
  onboarding        Onboarding flow with multiple pages
  home              Home screen with navigation
  api               API configuration with Dio
  feature           Custom feature with clean architecture
  full-app          Complete application with all features

🎛️ COMMON OPTIONS:
  --clean-architecture         Use clean architecture (default: true)
  --navigation-type=TYPE       Navigation type: bottom, sidebar, both
  --tabs-count=N              Number of navigation tabs (default: 3)
  --include-animations        Include animations (default: true)
  --include-recovery          Include password recovery (default: true)
  --use-dio                   Use Dio for HTTP (default: true)

💡 EXAMPLES:
  flutter_app_gen generate auth MyAuth --include-recovery
  flutter_app_gen generate home --navigation-type=sidebar --tabs-count=5
  flutter_app_gen generate full-app MyApp --navigation-type=both
''');
  }

  void _showVersion() {
    ConsoleUtils.info('Flutter App Base Generator v1.0.0');
  }
}
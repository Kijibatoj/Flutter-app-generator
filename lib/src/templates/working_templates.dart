class WorkingTemplates {
  
  /// Genera main.dart funcional basado en el proyecto de referencia
  static String generateWorkingMain(String appName) {
    final className = _pascalCase(appName);
    return '''
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

// Core imports
import 'configs/config.dart';
import 'configs/theme/app_theme.dart';
import 'shared/common/common.dart';

// Screens
import 'screen/auth/login_screen.dart';
import 'screen/splash/splash_screen.dart';
import 'screen/home/home_screen.dart';

Future<void> main() async {
  Intl.defaultLocale = 'es';
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Future<void> _initialCharge() async {
    // Inicialización de la app
  }

  @override
  void initState() {
    super.initState();
    _initialCharge();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$className',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash",
      routes: {
        '/splash': (context) => SplashScreen(
              onInit: () async {
                // Inicialización
              },
            ),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],
    );
  }
}
''';
  }

  /// Genera configuración basada en el proyecto de referencia
  static String generateConfig() {
    return '''
export 'constants/env.dart';
export 'constants/secure_storage.dart';
export 'theme/app_theme.dart';
''';
  }

  /// Genera constants/env.dart
  static String generateEnv() {
    return '''
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_URL', defaultValue: 'https://api.example.com')
  static const String apiUrl = _Env.apiUrl;
  
  @EnviedField(varName: 'APP_NAME', defaultValue: 'Mi App')
  static const String appName = _Env.appName;
  
  @EnviedField(varName: 'DEBUG', defaultValue: true)
  static const bool debug = _Env.debug;
}
''';
  }

  /// Genera secure_storage.dart basado en el proyecto de referencia
  static String generateSecureStorage() {
    return '''
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  ),
);

// Keys
const String tokenKey = 'user_token';
const String userDataKey = 'user_data';
const String profileKey = 'user_profile';
const String loginCredentialKey = 'login_credential';

// Token operations
Future<void> setToken(String token) async {
  await storage.write(key: tokenKey, value: token);
}

Future<String?> getToken() async {
  return await storage.read(key: tokenKey);
}

Future<void> deleteToken() async {
  await storage.delete(key: tokenKey);
}

// User data operations
Future<void> saveDataUser(Map<String, dynamic> userData) async {
  await storage.write(key: userDataKey, value: userData.toString());
}

Future<void> saveProfile(Map<String, dynamic> profile) async {
  await storage.write(key: profileKey, value: profile.toString());
}

Future<Map<String, dynamic>?> getProfile() async {
  final data = await storage.read(key: profileKey);
  if (data != null) {
    // Aquí deberías parsear la data correctamente
    return {}; // Placeholder
  }
  return null;
}

Future<void> saveLoginCredential(String credential) async {
  await storage.write(key: loginCredentialKey, value: credential);
}

Future<void> deleteAll() async {
  await storage.deleteAll();
}
''';
  }

  /// Genera common.dart
  static String generateCommon() {
    return '''
export 'alert_dialog.dart';
export 'check_internet.dart';
export 'data_user.dart';
export 'helper.dart';
export 'snackbar.dart';
''';
  }

  /// Genera check_internet.dart
  static String generateCheckInternet() {
    return '''
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> checkInternet() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }
  
  try {
    final result = await InternetConnectionChecker().hasConnection;
    return result;
  } catch (e) {
    return false;
  }
}
''';
  }

  /// Genera data_user.dart
  static String generateDataUser() {
    return '''
import '../../../configs/constants/secure_storage.dart';

// User session management
int _unreadNotifications = 0;

void setUnreadNotifications(int count) {
  _unreadNotifications = count;
}

int getUnreadNotifications() {
  return _unreadNotifications;
}

Future<String?> getIdUser() async {
  // Implementar lógica para obtener ID del usuario desde el token
  final token = await getToken();
  if (token != null) {
    // Decodificar JWT y extraer ID
    // Placeholder por ahora
    return "user_id";
  }
  return null;
}
''';
  }

  /// Genera helper.dart
  static String generateHelper() {
    return '''
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatDateTime(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
}

void showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 3),
    ),
  );
}

String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
''';
  }

  /// Genera SplashScreen funcional
  static String generateSplashScreen() {
    return '''
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Future<void> Function()? onInit;
  
  const SplashScreen({super.key, this.onInit});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Iniciar animación
      _controller.forward();
      
      // Ejecutar inicialización personalizada si existe
      if (widget.onInit != null) {
        await widget.onInit!();
      }
      
      // Esperar mínimo 3 segundos para mostrar el splash
      await Future.delayed(const Duration(seconds: 3));
      
      // Navegar a la siguiente pantalla
      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      // En caso de error, navegar de todos modos
      if (mounted) {
        _navigateToNextScreen();
      }
    }
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.flutter_dash,
                          size: 60,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Mi App',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              FadeTransition(
                opacity: _fadeAnimation,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
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

  /// Genera LoginScreen funcional
  static String generateLoginScreen() {
    return '''
import 'package:flutter/material.dart';
import '../../shared/widgets/forms/label_text_form_field.dart';
import '../../shared/common/common.dart';
import '../../controllers/users.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await loginUser(
        _usernameController.text,
        _passwordController.text,
      );

      if (mounted) {
        if (result['isExitoso'] == true) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          showCustomSnackBar(
            context, 
            result['message'] ?? 'Error al iniciar sesión',
            isError: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(
          context, 
          'Error inesperado: \$e',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Text(
                    'Iniciar Sesión',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Username field
                  LabelTextFormField(
                    controller: _usernameController,
                    labelText: 'Usuario o Email',
                    hintText: 'Ingresa tu usuario o email',
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es requerido';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Password field
                  LabelTextFormField(
                    controller: _passwordController,
                    labelText: 'Contraseña',
                    hintText: 'Ingresa tu contraseña',
                    prefixIcon: Icons.lock,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es requerido';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Iniciar Sesión'),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Register link
                  TextButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('¿No tienes cuenta? Regístrate'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
''';
  }

  /// Genera HomeScreen funcional
  static String generateHomeScreen() {
    return '''
import 'package:flutter/material.dart';
import 'modules/home_section.dart';
import 'modules/profile_section.dart';
import '../../shared/widgets/side_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const HomeSection(),
    const Center(child: Text('Búsqueda')),
    const Center(child: Text('Favoritos')),
    const ProfileSection(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      drawer: const SideMenu(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
''';
  }

  /// Genera LabelTextFormField
  static String generateLabelTextFormField() {
    return '''
import 'package:flutter/material.dart';

class LabelTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines;

  const LabelTextFormField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onTap: onTap,
          readOnly: readOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
        ),
      ],
    );
  }
}
''';
  }

  /// Genera controllers/users.dart basado en el proyecto de referencia
  static String generateUsersController() {
    return '''
import 'dart:convert';
import 'dart:io';
import '../configs/config.dart';
import '../shared/common/check_internet.dart';
import '../shared/common/data_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final apiUrl = Env.apiUrl;

Future<Map<String, dynamic>> loginUser(String username, String password) async {
  try {
    return await _handleLoginWithHttpRequest(username.trim(), password.trim());
  } catch (e) {
    debugPrint('Error: \$e');
    return _buildErrorResponse('Ha ocurrido un error, intente nuevamente');
  }
}

Future<Map<String, dynamic>> _handleLoginWithHttpRequest(
    String username, String pass) async {
  bool hasInternet = await checkInternet();

  if (!hasInternet) {
    return _buildErrorResponse("No hay conexión a internet");
  }

  debugPrint('intento de autenticacion por http');
  final pathURL = '\$apiUrl/auth/login';
  debugPrint(pathURL);

  var request = http.Request('POST', Uri.parse(pathURL))
    ..body = jsonEncode({
      "credential": username.trim(),
      "password": pass.trim(),
      "type": "aspirante"
    })
    ..headers.addAll({'Content-Type': 'application/json'});

  http.StreamedResponse response = await request.send();
  return await _processResponse(response, username);
}

Future<Map<String, dynamic>> _processResponse(
    http.StreamedResponse response, String username) async {
  Map<String, dynamic> data = {};

  if (response.statusCode == 201) {
    String body = await response.stream.bytesToString();
    data = jsonDecode(body);
    if (data["access_token"] != null) {
      String accessToken = data["access_token"];
      Map<String, dynamic> decodedToken = _decodeJwt(accessToken);

      await _saveUserData(decodedToken, accessToken, loginUsername: username);
      return _buildSuccessResponse();
    }
    return _buildErrorResponse(data["message"], code: 401);
  }

  String body = await response.stream.bytesToString();
  data = jsonDecode(body);

  return (data["access_token"] == null)
      ? _buildErrorResponse(data["message"])
      : _buildErrorResponse("Error desconocido");
}

Future<void> _saveUserData(
    Map<String, dynamic> data, String accessToken, {String? loginUsername}) async {
  await saveDataUser(data);
  await setToken(accessToken);
  if (loginUsername != null) {
    await saveLoginCredential(loginUsername);
  }
}

Map<String, dynamic> _buildSuccessResponse() {
  return {
    "code": 200,
    "isExitoso": true,
    "title": "Inicio de sesión",
    "message": "Inicio de sesión exitoso",
  };
}

Map<String, dynamic> _buildErrorResponse(String message, {int? code}) {
  return {
    "code": code ?? 500,
    "isExitoso": false,
    "title": "Inicio de sesión",
    "message": message,
  };
}

Map<String, dynamic> _decodeJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('Invalid JWT');
  }

  final payload = parts[1];
  final normalized = base64Url.normalize(payload);
  final decoded = utf8.decode(base64Url.decode(normalized));

  return jsonDecode(decoded);
}
''';
  }

  // Método auxiliar para convertir a PascalCase
  static String _pascalCase(String text) {
    return text.split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join('');
  }
}
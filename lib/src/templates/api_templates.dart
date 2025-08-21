class ApiTemplates {
  String generateApiService(String serviceName, Map<String, dynamic> options) {
    final useDio = options['use-dio'] ?? true;
    final includeInterceptors = options['include-interceptors'] ?? true;
    final includeConnectivity = options['include-connectivity'] ?? true;
    final useSecureStorage = options['use-secure-storage'] ?? true;
    final baseUrl = options['base-url'] ?? 'https://api.example.com';

    return '''
${useDio ? "import 'package:dio/dio.dart';" : "import 'dart:convert';\nimport 'dart:io';"}
import 'package:flutter/foundation.dart';
${useSecureStorage ? "import 'package:flutter_secure_storage/flutter_secure_storage.dart';" : ""}
${includeConnectivity ? "import 'package:connectivity_plus/connectivity_plus.dart';" : ""}

class ${_pascalCase(serviceName)} {
  ${useDio ? 'late final Dio _dio;' : 'late final HttpClient _httpClient;'}
  ${useSecureStorage ? 'static const _storage = FlutterSecureStorage();' : ''}
  static const String _baseUrl = '$baseUrl';
  
  static final ${_pascalCase(serviceName)} _instance = ${_pascalCase(serviceName)}._internal();
  factory ${_pascalCase(serviceName)}() => _instance;
  ${_pascalCase(serviceName)}._internal() {
    ${useDio ? '_initializeDio();' : '_initializeHttpClient();'}
  }

  ${useDio ? '''
  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      sendTimeout: Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));

    ${includeInterceptors ? '''
    _dio.interceptors.add(_AuthInterceptor());
    
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
    ''' : ''}
  }
  ''' : '''
  void _initializeHttpClient() {
    _httpClient = HttpClient();
    _httpClient.connectionTimeout = Duration(seconds: 30);
  }
  '''}

  ${includeConnectivity ? '''
  Future<bool> _hasConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return !connectivityResult.contains(ConnectivityResult.none);
    } catch (e) {
      debugPrint('Error checking connectivity: \$e');
      return false;
    }
  }
  ''' : ''}

  ${useSecureStorage ? '''
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'auth_token');
    } catch (e) {
      debugPrint('Error reading token: \$e');
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: 'auth_token', value: token);
    } catch (e) {
      debugPrint('Error saving token: \$e');
    }
  }

  Future<void> removeToken() async {
    try {
      await _storage.delete(key: 'auth_token');
    } catch (e) {
      debugPrint('Error removing token: \$e');
    }
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _storage.write(key: 'refresh_token', value: refreshToken);
    } catch (e) {
      debugPrint('Error saving refresh token: \$e');
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: 'refresh_token');
    } catch (e) {
      debugPrint('Error reading refresh token: \$e');
      return null;
    }
  }
  ''' : ''}

  // GET Request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    ${includeConnectivity ? '''
    if (!await _hasConnection()) {
      throw ApiException('No hay conexión a internet', 0);
    }
    ''' : ''}

    try {
      ${useDio ? '''
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
      ''' : '''
      final uri = Uri.parse('\$_baseUrl\$endpoint');
      if (queryParameters != null) {
        uri = uri.replace(queryParameters: queryParameters);
      }
      
      final request = await _httpClient.getUrl(uri);
      headers?.forEach((key, value) => request.headers.add(key, value));
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      return _handleHttpResponse(response.statusCode, responseBody);
      '''}
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST Request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    ${includeConnectivity ? '''
    if (!await _hasConnection()) {
      throw ApiException('No hay conexión a internet', 0);
    }
    ''' : ''}

    try {
      ${useDio ? '''
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
      ''' : '''
      final uri = Uri.parse('\$_baseUrl\$endpoint');
      final request = await _httpClient.postUrl(uri);
      
      request.headers.contentType = ContentType.json;
      headers?.forEach((key, value) => request.headers.add(key, value));
      
      if (data != null) {
        request.write(jsonEncode(data));
      }
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      return _handleHttpResponse(response.statusCode, responseBody);
      '''}
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT Request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    ${includeConnectivity ? '''
    if (!await _hasConnection()) {
      throw ApiException('No hay conexión a internet', 0);
    }
    ''' : ''}

    try {
      ${useDio ? '''
      final response = await _dio.put(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
      ''' : '''
      final uri = Uri.parse('\$_baseUrl\$endpoint');
      final request = await _httpClient.openUrl('PUT', uri);
      
      request.headers.contentType = ContentType.json;
      headers?.forEach((key, value) => request.headers.add(key, value));
      
      if (data != null) {
        request.write(jsonEncode(data));
      }
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      return _handleHttpResponse(response.statusCode, responseBody);
      '''}
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE Request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    ${includeConnectivity ? '''
    if (!await _hasConnection()) {
      throw ApiException('No hay conexión a internet', 0);
    }
    ''' : ''}

    try {
      ${useDio ? '''
      final response = await _dio.delete(
        endpoint,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
      ''' : '''
      final uri = Uri.parse('\$_baseUrl\$endpoint');
      final request = await _httpClient.deleteUrl(uri);
      
      headers?.forEach((key, value) => request.headers.add(key, value));
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      return _handleHttpResponse(response.statusCode, responseBody);
      '''}
    } catch (e) {
      throw _handleError(e);
    }
  }

  ${useDio ? '''
  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else if (response.data is List) {
        return {'data': response.data};
      } else {
        return {'message': 'Success', 'data': response.data};
      }
    } else {
      throw ApiException(
        response.data?['message'] ?? 'Error del servidor',
        response.statusCode ?? 0,
        response.data,
      );
    }
  }
  ''' : '''
  Map<String, dynamic> _handleHttpResponse(int statusCode, String responseBody) {
    if (statusCode >= 200 && statusCode < 300) {
      try {
        final decoded = jsonDecode(responseBody);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else if (decoded is List) {
          return {'data': decoded};
        } else {
          return {'message': 'Success', 'data': decoded};
        }
      } catch (e) {
        return {'message': 'Success', 'data': responseBody};
      }
    } else {
      try {
        final errorData = jsonDecode(responseBody);
        throw ApiException(
          errorData['message'] ?? 'Error del servidor',
          statusCode,
          errorData,
        );
      } catch (e) {
        throw ApiException(
          'Error del servidor',
          statusCode,
          {'message': responseBody},
        );
      }
    }
  }
  '''}

  ApiException _handleError(dynamic error) {
    ${useDio ? '''
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ApiException('Tiempo de conexión agotado', 0);
        case DioExceptionType.sendTimeout:
          return ApiException('Tiempo de envío agotado', 0);
        case DioExceptionType.receiveTimeout:
          return ApiException('Tiempo de respuesta agotado', 0);
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode ?? 0;
          final message = error.response?.data?['message'] ?? 
                          error.response?.statusMessage ?? 
                          'Error del servidor';
          return ApiException(message, statusCode, error.response?.data);
        case DioExceptionType.cancel:
          return ApiException('Solicitud cancelada', 0);
        case DioExceptionType.connectionError:
          return ApiException('Error de conexión', 0);
        case DioExceptionType.unknown:
        default:
          return ApiException('Error desconocido: \${error.message}', 0);
      }
    }
    ''' : '''
    if (error is SocketException) {
      return ApiException('Error de conexión a internet', 0);
    } else if (error is HttpException) {
      return ApiException('Error HTTP: \${error.message}', 0);
    } else if (error is FormatException) {
      return ApiException('Error en el formato de respuesta', 0);
    }
    '''}
    
    return ApiException('Error inesperado: \$error', 0);
  }

  void dispose() {
    ${useDio ? '_dio.close();' : '_httpClient.close();'}
  }
}

${includeInterceptors && useDio ? '''
class _AuthInterceptor extends Interceptor {
  ${useSecureStorage ? 'static const _storage = FlutterSecureStorage();' : ''}

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    ${useSecureStorage ? '''
    final token = await _storage.read(key: 'auth_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer \$token';
    }
    ''' : ''}
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      ${useSecureStorage ? '''
      // Token expirado, intentar renovar
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          await _refreshToken(refreshToken);
          // Reintentar la solicitud original
          final clonedRequest = await _retryRequest(err.requestOptions);
          handler.resolve(clonedRequest);
          return;
        } catch (e) {
          // Error al renovar token, redirigir a login
          await _storage.deleteAll();
        }
      } else {
        await _storage.deleteAll();
      }
      ''' : '''
      // Token inválido, limpiar almacenamiento
      '''}
    }
    handler.next(err);
  }

  ${useSecureStorage ? '''
  Future<void> _refreshToken(String refreshToken) async {
    final dio = Dio();
    final response = await dio.post(
      '\${${_pascalCase(serviceName)}._instance._baseUrl}/auth/refresh',
      data: {'refresh_token': refreshToken},
    );

    if (response.statusCode == 200) {
      final newToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];
      
      await _storage.write(key: 'auth_token', value: newToken);
      if (newRefreshToken != null) {
        await _storage.write(key: 'refresh_token', value: newRefreshToken);
      }
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final token = await _storage.read(key: 'auth_token');
    requestOptions.headers['Authorization'] = 'Bearer \$token';
    
    final dio = Dio();
    return await dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }
  ''' : ''}
}
''' : ''}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final dynamic data;

  const ApiException(this.message, this.statusCode, [this.data]);

  @override
  String toString() {
    return 'ApiException: \$message (Status: \$statusCode)';
  }

  bool get isNetworkError => statusCode == 0;
  bool get isServerError => statusCode >= 500;
  bool get isClientError => statusCode >= 400 && statusCode < 500;
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
}
''';
  }

  String generateSecureStorage() {
    return '''
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Claves de almacenamiento
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _settingsKey = 'app_settings';

  // Token de autenticación
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: _authTokenKey);
  }

  Future<void> removeAuthToken() async {
    await _storage.delete(key: _authTokenKey);
  }

  // Refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> removeRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  // Datos del usuario
  Future<void> saveUserData(String userData) async {
    await _storage.write(key: _userDataKey, value: userData);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: _userDataKey);
  }

  Future<void> removeUserData() async {
    await _storage.delete(key: _userDataKey);
  }

  // Configuraciones de la app
  Future<void> saveSettings(String settings) async {
    await _storage.write(key: _settingsKey, value: settings);
  }

  Future<String?> getSettings() async {
    return await _storage.read(key: _settingsKey);
  }

  Future<void> removeSettings() async {
    await _storage.delete(key: _settingsKey);
  }

  // Operaciones generales
  Future<void> saveValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getValue(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> removeValue(String key) async {
    await _storage.delete(key: key);
  }

  Future<Map<String, String>> getAllValues() async {
    return await _storage.readAll();
  }

  Future<bool> hasValue(String key) async {
    final value = await _storage.read(key: key);
    return value != null;
  }

  // Limpiar todo el almacenamiento
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Limpiar solo datos de sesión
  Future<void> clearSession() async {
    await removeAuthToken();
    await removeRefreshToken();
    await removeUserData();
  }
}
''';
  }

  String generateConnectivityService() {
    return '''
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  bool _hasConnection = true;
  bool get hasConnection => _hasConnection;

  // Stream para escuchar cambios de conectividad
  Stream<bool> get connectivityStream => _connectivity.onConnectivityChanged
      .map((results) => !results.contains(ConnectivityResult.none));

  // Iniciar monitoreo de conectividad
  void startMonitoring(BuildContext context) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final hasConnection = !results.contains(ConnectivityResult.none);
        _updateConnectionStatus(hasConnection, context);
      },
    );
    
    // Verificar estado inicial
    _checkInitialConnectivity(context);
  }

  // Parar monitoreo de conectividad
  void stopMonitoring() {
    _connectivitySubscription?.cancel();
  }

  // Verificar conectividad actual
  Future<bool> checkConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      final hasConnection = !results.contains(ConnectivityResult.none);
      _hasConnection = hasConnection;
      return hasConnection;
    } catch (e) {
      _hasConnection = false;
      return false;
    }
  }

  // Obtener tipo de conexión
  Future<ConnectivityResult> getConnectionType() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      return results.isNotEmpty ? results.first : ConnectivityResult.none;
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  // Verificar si hay conexión WiFi
  Future<bool> isConnectedToWiFi() async {
    final connectionType = await getConnectionType();
    return connectionType == ConnectivityResult.wifi;
  }

  // Verificar si hay conexión móvil
  Future<bool> isConnectedToMobile() async {
    final connectionType = await getConnectionType();
    return connectionType == ConnectivityResult.mobile;
  }

  // Verificar conectividad inicial
  Future<void> _checkInitialConnectivity(BuildContext context) async {
    final hasConnection = await checkConnectivity();
    if (context.mounted) {
      _updateConnectionStatus(hasConnection, context);
    }
  }

  // Actualizar estado de conexión
  void _updateConnectionStatus(bool hasConnection, BuildContext context) {
    if (_hasConnection != hasConnection) {
      _hasConnection = hasConnection;
      
      if (context.mounted) {
        _showConnectivitySnackBar(context, hasConnection);
      }
    }
  }

  // Mostrar SnackBar de estado de conectividad
  void _showConnectivitySnackBar(BuildContext context, bool hasConnection) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            hasConnection ? Icons.wifi : Icons.wifi_off,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              hasConnection 
                  ? 'Conexión restaurada' 
                  : 'Sin conexión a internet',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: hasConnection ? Colors.green : Colors.red,
      duration: Duration(seconds: hasConnection ? 2 : 4),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Mostrar dialog de no conectividad
  void showNoConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.red),
              SizedBox(width: 8),
              Text('Sin Conexión'),
            ],
          ),
          content: Text(
            'No hay conexión a internet disponible. Verifica tu conexión y vuelve a intentar.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final hasConnection = await checkConnectivity();
                if (!hasConnection && context.mounted) {
                  showNoConnectionDialog(context);
                }
              },
              child: Text('Reintentar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Ejecutar función solo si hay conexión
  Future<T?> executeWithConnection<T>(
    BuildContext context,
    Future<T> Function() function, {
    bool showDialog = true,
  }) async {
    final hasConnection = await checkConnectivity();
    
    if (!hasConnection) {
      if (showDialog && context.mounted) {
        showNoConnectionDialog(context);
      }
      return null;
    }
    
    return await function();
  }

  void dispose() {
    stopMonitoring();
  }
}
''';
  }

  String _pascalCase(String text) {
    return text.split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join('');
  }
}
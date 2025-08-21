class CoreTemplates {
  
  // DATABASE TEMPLATES

  /// Genera configuración de base de datos SQLite
  static String generateDatabaseConfig() {
    return '''import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConfig {
  static const String _databaseName = 'app_database.db';
  static const int _databaseVersion = 1;
  
  static Database? _database;
  
  // Singleton pattern
  static final DatabaseConfig _instance = DatabaseConfig._internal();
  factory DatabaseConfig() => _instance;
  DatabaseConfig._internal();
  
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla de usuarios
    await db.execute(\'''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    \''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementar migraciones aquí
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('users');
  }

  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}''';
  }

  /// Genera repositorio base genérico
  static String generateBaseRepository() {
    return '''
import 'package:sqflite/sqflite.dart';
import '../database/database_config.dart';

abstract class BaseRepository<T> {
  final DatabaseConfig _dbConfig = DatabaseConfig();
  
  String get tableName;
  
  T fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap(T entity);
  
  Future<int> insert(T entity) async {
    try {
      final db = await _dbConfig.database;
      final map = toMap(entity);
      
      map['created_at'] ??= DateTime.now().toIso8601String();
      map['updated_at'] ??= DateTime.now().toIso8601String();
      
      return await db.insert(tableName, map);
    } catch (e) {
      throw Exception('Error insertando en \$tableName: \$e');
    }
  }

  Future<List<T>> findAll() async {
    try {
      final db = await _dbConfig.database;
      final maps = await db.query(tableName);
      return maps.map((map) => fromMap(map)).toList();
    } catch (e) {
      throw Exception('Error consultando \$tableName: \$e');
    }
  }

  Future<T?> findById(int id) async {
    try {
      final db = await _dbConfig.database;
      final maps = await db.query(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      
      if (maps.isNotEmpty) {
        return fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Error buscando por ID en \$tableName: \$e');
    }
  }

  Future<int> update(int id, T entity) async {
    try {
      final db = await _dbConfig.database;
      final map = toMap(entity);
      map['updated_at'] = DateTime.now().toIso8601String();
      
      return await db.update(
        tableName,
        map,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error actualizando en \$tableName: \$e');
    }
  }

  Future<int> delete(int id) async {
    try {
      final db = await _dbConfig.database;
      return await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error eliminando en \$tableName: \$e');
    }
  }
}
''';
  }

  /// Genera repositorio de usuario como ejemplo
  static String generateUserRepository() {
    return '''
import '../base_repository.dart';

class User {
  final int? id;
  final String uuid;
  final String email;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.uuid,
    required this.email,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });
}

class UserRepository extends BaseRepository<User> {
  @override
  String get tableName => 'users';

  @override
  User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt(),
      uuid: map['uuid'],
      email: map['email'],
      name: map['name'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  @override
  Map<String, dynamic> toMap(User entity) {
    return {
      'id': entity.id,
      'uuid': entity.uuid,
      'email': entity.email,
      'name': entity.name,
      'created_at': entity.createdAt?.toIso8601String(),
      'updated_at': entity.updatedAt?.toIso8601String(),
    };
  }

  Future<User?> findByEmail(String email) async {
    try {
      final db = await _dbConfig.database;
      final maps = await db.query(
        tableName,
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      
      if (maps.isNotEmpty) {
        return fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Error buscando usuario por email: \$e');
    }
  }
}
''';
  }

  /// Genera configuración de Drift (ORM más avanzado)
  static String generateDriftDatabase() {
    return '''
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Tablas
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get email => text().unique()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// Database class
@DriftDatabase(tables: [Users])
class AppDatabase extends _\$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // User queries
  Future<List<User>> getAllUsers() => select(users).get();
  
  Future<User?> getUserById(int id) => 
    (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
    
  Future<User?> getUserByEmail(String email) =>
    (select(users)..where((u) => u.email.equals(email))).getSingleOrNull();

  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);
  
  Future<bool> updateUser(int id, UsersCompanion user) => 
    update(users..where((u) => u.id.equals(id))).replace(user);
    
  Future<int> deleteUser(int id) => 
    (delete(users)..where((u) => u.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    
    return NativeDatabase.createInBackground(file);
  });
}
''';
  }

  /// Genera configuración de red completa
  static String generateNetworkConfig() {
    return '''
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkConfig {
  static const String baseUrl = 'https://api.example.com/v1';
  static const int timeout = 30;
  
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Future<http.Response> get(String endpoint) async {
    final uri = Uri.parse('\$baseUrl\$endpoint');
    
    return await http.get(
      uri,
      headers: headers,
    ).timeout(Duration(seconds: timeout));
  }
  
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.parse('\$baseUrl\$endpoint');
    
    return await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    ).timeout(Duration(seconds: timeout));
  }
  
  static Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.parse('\$baseUrl\$endpoint');
    
    return await http.put(
      uri,
      headers: headers,
      body: jsonEncode(data),
    ).timeout(Duration(seconds: timeout));
  }
  
  static Future<http.Response> delete(String endpoint) async {
    final uri = Uri.parse('\$baseUrl\$endpoint');
    
    return await http.delete(
      uri,
      headers: headers,
    ).timeout(Duration(seconds: timeout));
  }
}
''';
  }

  /// Genera servicio de almacenamiento seguro
  static String generateSecureStorageService() {
    return '''
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  // Keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  
  // Tokens
  static Future<void> setAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }
  
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }
  
  static Future<void> setRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }
  
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }
  
  // User ID
  static Future<void> setUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }
  
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }
  
  // General operations
  static Future<void> setValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
  
  static Future<String?> getValue(String key) async {
    return await _storage.read(key: key);
  }
  
  static Future<void> deleteValue(String key) async {
    await _storage.delete(key: key);
  }
  
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
  
  static Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
''';
  }
}
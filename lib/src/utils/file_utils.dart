import 'dart:io';

class FileUtils {
  /// Escribe contenido a un archivo
  static Future<void> writeFile(String path, String content) async {
    final file = File(path);
    
    // Crear directorio padre si no existe
    final directory = file.parent;
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    
    await file.writeAsString(content);
  }

  /// Lee contenido de un archivo
  static Future<String> readFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw FileSystemException('Archivo no encontrado: $path');
    }
    return await file.readAsString();
  }

  /// Verifica si un archivo existe
  static Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  /// Verifica si un directorio existe
  static Future<bool> directoryExists(String path) async {
    return await Directory(path).exists();
  }

  /// Crea un directorio
  static Future<void> createDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  /// Lista archivos en un directorio
  static Future<List<String>> listFiles(String path, {String? extension}) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      return [];
    }
    
    final files = <String>[];
    await for (var entity in directory.list()) {
      if (entity is File) {
        if (extension == null || entity.path.endsWith(extension)) {
          files.add(entity.path);
        }
      }
    }
    
    return files;
  }

  /// Copia un archivo
  static Future<void> copyFile(String sourcePath, String destinationPath) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw FileSystemException('Archivo fuente no encontrado: $sourcePath');
    }
    
    final destinationFile = File(destinationPath);
    final directory = destinationFile.parent;
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    
    await sourceFile.copy(destinationPath);
  }

  /// Elimina un archivo
  static Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Elimina un directorio
  static Future<void> deleteDirectory(String path) async {
    final directory = Directory(path);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  /// Renombra un archivo o directorio
  static Future<void> rename(String oldPath, String newPath) async {
    final entity = await FileSystemEntity.type(oldPath);
    
    if (entity == FileSystemEntityType.file) {
      await File(oldPath).rename(newPath);
    } else if (entity == FileSystemEntityType.directory) {
      await Directory(oldPath).rename(newPath);
    } else {
      throw FileSystemException('Entidad no encontrada: $oldPath');
    }
  }

  /// Obtiene el tamaño de un archivo
  static Future<int> getFileSize(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw FileSystemException('Archivo no encontrado: $path');
    }
    
    final stat = await file.stat();
    return stat.size;
  }

  /// Obtiene la fecha de modificación de un archivo
  static Future<DateTime> getModificationDate(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw FileSystemException('Archivo no encontrado: $path');
    }
    
    final stat = await file.stat();
    return stat.modified;
  }

  /// Reemplaza texto en un archivo
  static Future<void> replaceInFile(String path, String search, String replacement) async {
    final content = await readFile(path);
    final newContent = content.replaceAll(search, replacement);
    await writeFile(path, newContent);
  }

  /// Añade contenido al final de un archivo
  static Future<void> appendToFile(String path, String content) async {
    final file = File(path);
    await file.writeAsString(content, mode: FileMode.append);
  }

  /// Crea un archivo desde un template
  static Future<void> createFromTemplate(String templatePath, String outputPath, Map<String, String> replacements) async {
    String content = await readFile(templatePath);
    
    for (final entry in replacements.entries) {
      content = content.replaceAll('{{${entry.key}}}', entry.value);
    }
    
    await writeFile(outputPath, content);
  }

  /// Obtiene la extensión de un archivo
  static String getFileExtension(String path) {
    final lastDot = path.lastIndexOf('.');
    if (lastDot == -1 || lastDot == path.length - 1) {
      return '';
    }
    return path.substring(lastDot + 1).toLowerCase();
  }

  /// Obtiene el nombre del archivo sin extensión
  static String getFileNameWithoutExtension(String path) {
    final fileName = path.split('/').last.split('\\').last;
    final lastDot = fileName.lastIndexOf('.');
    if (lastDot == -1) {
      return fileName;
    }
    return fileName.substring(0, lastDot);
  }

  /// Obtiene el directorio padre de una ruta
  static String getParentDirectory(String path) {
    return Directory(path).parent.path;
  }

  /// Normaliza una ruta según el sistema operativo
  static String normalizePath(String path) {
    if (Platform.isWindows) {
      return path.replaceAll('/', '\\');
    } else {
      return path.replaceAll('\\', '/');
    }
  }

  /// Combina rutas de manera segura
  static String joinPath(List<String> parts) {
    return parts.join(Platform.pathSeparator);
  }
}
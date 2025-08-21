# Configuración del PATH para Windows

## Índice
1. [Problema](#problema)
2. [Solución](#solución)
3. [Métodos de Configuración](#métodos-de-configuración)
4. [Verificación](#verificación)
5. [Uso Post-Configuración](#uso-post-configuración)
6. [Troubleshooting](#troubleshooting)

---

## Problema

El comando `flutter_app_gen` no se reconoce después de la instalación de la librería Flutter App Base Generator.

### Síntomas
- Error: `'flutter_app_gen' no se reconoce como un comando interno o externo`
- El comando no funciona desde cualquier directorio
- La librería está instalada pero no accesible globalmente

---

## Solución

El problema ocurre porque el directorio donde se instalan los ejecutables de Dart no está en el PATH del sistema. La librería instala los ejecutables en:

```
C:\Users\tuUsuario\AppData\Local\Pub\Cache\bin
```

---

## Métodos de Configuración

### Método 1: Instalación Automática (Recomendado)

El método más sencillo es usar el script de instalación automática:

```batch
install_local.bat
```

#### Qué hace el script:
- Activa la librería globalmente
- Configura el PATH automáticamente
- Verifica que la instalación sea correcta
- Proporciona feedback del proceso

#### Pasos:
1. Abrir una terminal en el directorio del proyecto
2. Ejecutar: `install_local.bat`
3. Seguir las instrucciones en pantalla
4. Reiniciar la terminal

### Método 2: Configuración Manual del PATH

Si prefieres configurar manualmente o el script automático no funciona:

#### Paso 1: Abrir Variables de Entorno
1. Presiona `Windows + R`
2. Escribe `sysdm.cpl` y presiona Enter
3. Ve a la pestaña "Opciones avanzadas"
4. Haz clic en "Variables de entorno..."

#### Paso 2: Editar PATH
1. En "Variables del sistema", busca y selecciona `Path`
2. Haz clic en "Editar..."
3. Haz clic en "Nuevo"
4. Agrega: `C:\Users\tuUsuario\AppData\Local\Pub\Cache\bin`
5. Haz clic en "Aceptar" en todas las ventanas

#### Paso 3: Reiniciar Terminal
1. Cierra todas las ventanas de terminal abiertas
2. Abre una nueva terminal
3. Prueba el comando: `flutter_app_gen --version`

### Método 3: Script de Configuración Personalizado

Si necesitas un script personalizado, puedes crear uno:

```batch
@echo off
echo Configurando PATH para Flutter App Base Generator...

set DART_PUB_CACHE=%LOCALAPPDATA%\Pub\Cache\bin

echo Verificando si %DART_PUB_CACHE% ya está en el PATH...

echo %PATH% | findstr /i "%DART_PUB_CACHE%" >nul
if %errorlevel% equ 0 (
    echo El directorio ya está en el PATH
) else (
    echo Agregando %DART_PUB_CACHE% al PATH del usuario...
    setx PATH "%PATH%;%DART_PUB_CACHE%"
    if %errorlevel% equ 0 (
        echo PATH configurado exitosamente
    ) else (
        echo Error al configurar el PATH
        pause
        exit /b 1
    )
)

echo.
echo Configuración completada!
echo Reinicia tu terminal para que los cambios surtan efecto
echo Prueba con: flutter_app_gen --version
echo.
pause
```

---

## Verificación

### Verificar que el PATH esté configurado

```bash
# Verificar si el directorio está en el PATH
echo %PATH% | findstr "Pub\\Cache\\bin"

# Si aparece la ruta, el PATH está configurado correctamente
```

### Verificar que el comando funcione

```bash
# Probar el comando
flutter_app_gen --version

# Ver la ayuda
flutter_app_gen --help

# Verificar que esté instalado globalmente
dart pub global list
```

### Resultados esperados

- `flutter_app_gen --version` debe mostrar: `Flutter App Base Generator v1.0.0`
- `flutter_app_gen --help` debe mostrar el menú de ayuda
- `dart pub global list` debe mostrar `flutter_app_base_generator`

---

## Uso Post-Configuración

Una vez configurado correctamente, puedes usar la librería desde cualquier directorio:

### Comandos Básicos

```bash
# Generar aplicación completa
flutter_app_gen generate full-app MiApp

# Generar componentes individuales
flutter_app_gen generate auth --clean-architecture
flutter_app_gen generate home --navigation-type=bottom
flutter_app_gen generate splash --include-animations

# Ver ayuda
flutter_app_gen help

# Ver versión
flutter_app_gen version
```

### Ejemplos de Uso

```bash
# Generar app con componentes neumórficos
flutter_app_gen generate full-app-with-neumorphic MiAppModerna

# Generar solo autenticación con Clean Architecture
flutter_app_gen generate auth MiAuth --clean-architecture

# Generar home con navegación lateral
flutter_app_gen generate home --navigation-type=sidebar --tabs-count=4
```

---

## Troubleshooting

### Problema: Comando no reconocido después de configurar PATH

#### Solución 1: Verificar PATH
```bash
# Verificar si el directorio está en el PATH
echo %PATH% | findstr "Pub\\Cache\\bin"

# Si no aparece, agregar manualmente
setx PATH "%PATH%;C:\Users\tuUsuario\AppData\Local\Pub\Cache\bin"
```

#### Solución 2: Verificar instalación
```bash
# Verificar que la librería esté instalada
dart pub global list

# Si no aparece, reinstalar
dart pub global activate --source path . --force
```

#### Solución 3: Reiniciar terminal
- Cerrar todas las terminales
- Abrir nueva terminal como administrador
- Probar el comando nuevamente

### Problema: Error de permisos

#### Solución:
1. Ejecutar terminal como administrador
2. O cambiar permisos de la carpeta:
   ```bash
   icacls "C:\Users\tuUsuario\AppData\Local\Pub\Cache\bin" /grant Users:F
   ```

### Problema: PATH demasiado largo

#### Solución:
1. Usar variables de entorno personalizadas
2. Crear enlaces simbólicos
3. Usar rutas relativas

### Verificación Completa

```bash
# Script de verificación completa
@echo off
echo Verificando instalación de Flutter App Base Generator...
echo.

echo 1. Verificando librería global...
dart pub global list | findstr flutter_app_base_generator
if %errorlevel% equ 0 (
    echo Librería instalada correctamente
) else (
    echo Librería no encontrada
    echo Ejecuta: dart pub global activate --source path .
)

echo.
echo 2. Verificando PATH...
echo %PATH% | findstr /i "Pub\\Cache\\bin" >nul
if %errorlevel% equ 0 (
    echo PATH configurado correctamente
) else (
    echo PATH no configurado
    echo Ejecuta: configure_path.bat
)

echo.
echo 3. Verificando comando...
flutter_app_gen --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Comando funciona correctamente
    echo.
    echo Instalación verificada exitosamente!
    echo.
    echo Comandos disponibles:
    echo   flutter_app_gen --help
    echo   flutter_app_gen generate full-app MiApp
) else (
    echo Comando no funciona
    echo Reinicia la terminal y vuelve a intentar
)

echo.
pause
```

---

## Recursos Adicionales

### Documentación Relacionada
- [COMAND.md](COMAND.md) - Documentación completa del proceso
- [README.md](README.md) - Documentación principal

---

@echo off
setlocal enabledelayedexpansion

REM ========================================
REM   FLUTTER APP BASE GENERATOR MANAGER
REM   Herramienta unificada para gestion
REM ========================================

echo.
echo ========================================
echo    FLUTTER APP BASE GENERATOR
echo   Herramienta de Gestion Unificada
echo ========================================
echo.

REM Verificar si se proporciono un parametro
if "%1"=="" goto :show_help

REM Procesar comandos
if /i "%1"=="install" goto :install
if /i "%1"=="verify" goto :verify
if /i "%1"=="configure" goto :configure
if /i "%1"=="status" goto :status
if /i "%1"=="help" goto :show_help
if /i "%1"=="--help" goto :show_help
if /i "%1"=="-h" goto :show_help
if /i "%1"=="update" goto :update
if /i "%1"=="clean" goto :clean
if /i "%1"=="version" goto :version

echo  Comando no reconocido: %1
echo.
goto :show_help

REM ========================================
REM INSTALACION COMPLETA
REM ========================================
:install
echo  Iniciando instalacion completa...
echo.

echo  Paso 1: Activando libreria globalmente...
dart pub global activate --source path .

if %errorlevel% neq 0 (
    echo  Error al activar la libreria
    echo  Verifica que Dart este instalado correctamente
    goto :end_error
)

echo  Libreria activada correctamente
echo.

echo  Paso 2: Configurando PATH...
call :configure_path

if %errorlevel% neq 0 (
    echo  Error al configurar PATH
    goto :end_error
)

echo.
echo  Paso 3: Verificando instalacion...
call :verify_installation

echo.
echo  Instalacion completada exitosamente!
echo.
echo  IMPORTANTE: Reinicia tu terminal para que los cambios surtan efecto
echo.
echo  Comandos disponibles:
echo    flutter_app_gen --version
echo    flutter_app_gen --help
echo    flutter_app_gen generate full-app MiApp
echo.
echo  Documentacion:
goto :end_success

REM ========================================
REM CONFIGURACION DE PATH
REM ========================================
:configure
:configure_path
echo  Configurando PATH para Flutter App Base Generator...

set DART_PUB_CACHE=%LOCALAPPDATA%\Pub\Cache\bin

echo  Verificando si %DART_PUB_CACHE% ya esta en el PATH...

echo %PATH% | findstr /i "%DART_PUB_CACHE%" >nul
if %errorlevel% equ 0 (
    echo El directorio ya esta en el PATH
    goto :end_success
)

echo  Agregando %DART_PUB_CACHE% al PATH del usuario...
setx PATH "%PATH%;%DART_PUB_CACHE%"

if %errorlevel% equ 0 (
    echo  PATH configurado exitosamente
    echo  Reinicia tu terminal para que los cambios surtan efecto
    goto :end_success
) else (
    echo  Error al configurar el PATH
    echo  Configuralo manualmente siguiendo las instrucciones:
    echo    1. Abre Variables de Entorno del Sistema
    echo    2. Edita la variable PATH del usuario
    echo    3. Agrega: %DART_PUB_CACHE%
    goto :end_error
)

REM ========================================
REM VERIFICACION DE INSTALACION
REM ========================================
:verify
:verify_installation
echo  Verificando instalacion...
echo.

echo  Verificando libreria global...
dart pub global list | findstr flutter_app_base_generator >nul
if %errorlevel% equ 0 (
    echo  Libreria instalada correctamente
) else (
    echo  Libreria no encontrada
    echo  Ejecuta: flutter_manager.bat install
    goto :end_error
)

echo.

echo  Verificando PATH...
echo %PATH% | findstr /i "Pub\\Cache\\bin" >nul
if %errorlevel% equ 0 (
    echo PATH configurado correctamente
) else (
    echo PATH no configurado
    echo Ejecuta: flutter_manager.bat configure
    goto :end_error
)

echo.

echo  Verificando comando...
flutter_app_gen --version >nul 2>&1
if %errorlevel% equ 0 (
    echo  Comando funciona correctamente
    echo.
    echo  Instalacion verificada exitosamente!
    echo.
    echo  Comandos disponibles:
    echo    flutter_app_gen --help
    echo    flutter_app_gen generate full-app MiApp
    echo    flutter_app_gen generate feature auth
    goto :end_success
) else (
    echo  Comando no funciona
    echo  Posibles soluciones:
    echo    1. Reinicia la terminal
    echo    2. Ejecuta: flutter_manager.bat configure
    echo    3. Verifica que Dart este instalado
    goto :end_error
)

REM ========================================
REM ESTADO DEL SISTEMA
REM ========================================
:status
echo  Estado del Sistema Flutter App Base Generator
echo ================================================
echo.

echo  Verificando Dart...
dart --version >nul 2>&1
if %errorlevel% equ 0 (
    echo  Dart instalado
    dart --version
) else (
    echo  Dart no encontrado
)

echo.

echo  Verificando Flutter...
flutter --version >nul 2>&1
if %errorlevel% equ 0 (
    echo  Flutter instalado
    flutter --version | head -n 1
) else (
    echo  Flutter no encontrado
)

echo.

echo  Verificando libreria global...
dart pub global list | findstr flutter_app_base_generator >nul
if %errorlevel% equ 0 (
    echo  Libreria global activa
    dart pub global list | findstr flutter_app_base_generator
) else (
    echo  Libreria global no activa
)

echo.

echo  Verificando PATH...
echo %PATH% | findstr /i "Pub\\Cache\\bin" >nul
if %errorlevel% equ 0 (
    echo  PATH configurado
) else (
    echo  PATH no configurado
)

echo.

echo  Verificando comando...
flutter_app_gen --version >nul 2>&1
if %errorlevel% equ 0 (
    echo  Comando disponible
    flutter_app_gen --version
) else (
    echo  Comando no disponible
)

goto :end_success

REM ========================================
REM ACTUALIZACION
REM ========================================
:update
echo  Actualizando Flutter App Base Generator...
echo.

echo  Paso 1: Desactivando version actual...
dart pub global deactivate flutter_app_base_generator >nul 2>&1

echo  Paso 2: Activando nueva version...
dart pub global activate --source path .

if %errorlevel% equ 0 (
    echo  Actualizacion completada exitosamente
    echo.
    echo  Paso 3: Verificando instalacion actualizada...
    call :verify_installation
    echo.
    echo  Libreria actualizada y verificada!
) else (
    echo  Error durante la actualizacion
    echo  Posibles soluciones:
    echo   1. Verifica que estes en el directorio correcto
    echo   2. Asegurate de que Dart este instalado
    echo   3. Ejecuta como administrador si es necesario
    goto :end_error
)

goto :end_success

REM ========================================
REM LIMPIEZA
REM ========================================
:clean
echo  Limpiando instalacion...
echo.

echo  Desactivando libreria global...
dart pub global deactivate flutter_app_base_generator

echo  Limpieza completada
echo  Para reinstalar, ejecuta: flutter_manager.bat install

goto :end_success

REM ========================================
REM VERSION
REM ========================================
:version
echo  Informacion de Version
echo ========================
echo.

if exist pubspec.yaml (
    echo  Paquete: Flutter App Base Generator
    findstr "version:" pubspec.yaml
    echo.
)

flutter_app_gen --version >nul 2>&1
if %errorlevel% equ 0 (
    echo  Comando activo:
    flutter_app_gen --version
) else (
    echo  Comando no disponible
)

goto :end_success

REM ========================================
REM AYUDA
REM ========================================
:show_help
echo  Uso: flutter_manager.bat [COMANDO]
echo.
echo  COMANDOS DISPONIBLES:
echo.
echo   install     Instala y configura completamente la herramienta
echo   verify      Verifica que la instalacion este funcionando
echo   configure   Configura unicamente el PATH del sistema
echo   status      Muestra el estado completo del sistema
echo   update      Actualiza a la ultima version
echo   clean       Desinstala la herramienta
echo   version     Muestra informacion de version
echo   help        Muestra esta ayuda
echo.
echo   EJEMPLOS DE USO:
echo.
echo   flutter_manager.bat install       # Instalacion completa
echo   flutter_manager.bat verify        # Verificar instalacion  
echo   flutter_manager.bat status        # Ver estado del sistema
echo   flutter_manager.bat update        # Actualizar herramienta
echo.
echo  DESPUES DE LA INSTALACION:
echo.
echo   flutter_app_gen --help                      # Ver ayuda del generador
echo   flutter_app_gen generate full-app MiApp    # Generar app completa
echo   flutter_app_gen generate feature auth      # Generar feature especifico
echo.
echo  Documentacion: En desarrollo 
goto :end_success

REM ========================================
REM FINALIZACION
REM ========================================
:end_success
echo.
echo  Operacion completada exitosamente
pause
exit /b 0

:end_error
echo.
echo  Se produjo un error durante la operacion
echo  Para mas ayuda, ejecuta: flutter_manager.bat help
echo.
pause
exit /b 1
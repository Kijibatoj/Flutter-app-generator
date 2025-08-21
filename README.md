## FLUTTER APP BASE GENERATOR
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)

## REQ:

Esta "Libreria" de flutter lo que hace es generar una aplicacion base y comandos base para crear componentes de forma rapida y que no se pierda tanto tiempo en crear conexiones a API, diseño y demas cosas, los componentes que ya se crean automaticamente con un diseño que se ve tanto en web como en cualquier dispositivo, es decir es responsive. 


# Instalación Local

### REQUISITOS PREVIOS

- [Dart SDK](https://dart.dev/get-dart) (versión 3.0.0 o superior)
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (opcional, para desarrollo)

## Instalacion Automática (Recomendado)

### 1.- Clonar el Repositorio 

```bash
git clone REPOSITORIO ACTUAL

cd flutter_app_base_generator

```

### 2.- Ejecutar script de instalación 

```batch
install_local.sh
 O puedes usar el comando general que 
```

Este script automaticamente: 
 - Activa la libreria globalmente en tu PC.
 - Configura el PATH del sistema.
 - Verifica que se hizo la instalación.

### 3.- Reiniciar terminal

Cierra y abre una nueva terminal para que los cambios del PATH surtan efecto. 


### 4.- Verificar instalación

Puedes usar el 

```batch
# Verificar versión
flutter_app_gen --version

# Ver ayuda
flutter_app_gen --help

# Generar una app completa
flutter_app_gen generate full-app <Nombre_app>
```

## Comandos Disponibles

### Generacion de Apps

```batch
# App Completa

flutter_app_gen generate full-app Miapp

# Componentes individuales

flutter_app_gen generate auth --clean-architecture
flutter_app_gen generate splash --animated
flutter_app_gen generate home --navigation-type=bottom
flutter_app_gen generate api --rest-client
```

### Configuración 

```batch
# Iniciar proyecto
flutter_app_gen init

# Configurar dependencias
flutter_app_gen setup dependencies
```

## Solución de Problemas

### Comando no reconocido

Si `flutter_app_gen` no se reconoce:

1. **Verificar PATH:**
    ```bash
    echo %PATH% | findstr "Pub\\Cache\\bin"
    ```
2. **Reconfigurar PATH:**
 ```batch
 # Utiliza este comando para ver el estado del sistema.
 flutter_manager.bat status

 # Este comando para verificar su instalación.
 flutter_manager.bat verify

 # En caso de que no este configurado el PATH usa:
 flutter_manager.bat clean
Este comando desintala la libreria, te tocara instalarla nuevamente

 # Comando de instalación
 flutter_manager.bat install
 ```

 ### 📚 Documentación
- [Guía de Uso](README.md)
- [Guía de Comandos]()
- [Configuración del PATH](PATH_SETUP.md)

 <img align="right" src="https://c.tenor.com/czt2nIJ1vb0AAAAd/tenor.gif" width = 300px>

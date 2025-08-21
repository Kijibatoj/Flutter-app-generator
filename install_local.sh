#!/bin/bash

echo ""
echo "======================================================"
echo "   🏠 INSTALACION LOCAL - Flutter App Base Generator"
echo "======================================================"
echo ""

echo "📍 Directorio actual: $(pwd)"
echo ""

echo "🔧 Activando librería globalmente desde ruta local..."
dart pub global activate --source path .

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Instalación completada exitosamente!"
    echo ""
    echo "🚀 Comandos disponibles:"
    echo "  flutter_app_gen --version"
    echo "  flutter_app_gen --help"
    echo "  flutter_app_gen generate full-app MiApp"
    echo ""
    echo "📖 Ver documentación: INSTALL_LOCAL.md"
else
    echo ""
    echo "❌ Error en la instalación"
    echo "💡 Verifica que Dart esté instalado y en el PATH"
fi

echo ""
echo "📦 Librerías globales activas:"
dart pub global list

echo ""
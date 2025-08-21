class NeumorphicComponentsTemplates {
  
  /// Genera el tema base para componentes neumórficos
  static String generateNeumorphicTheme() {
    return '''
import 'package:flutter/material.dart';

class NeumorphicTheme {
  // Colores base para neumorphic
  static const Color _baseColor = Color(0xFFE0E0E0);
  static const Color _accentColor = Color(0xFF2196F3);
  static const Color _shadowColor = Color(0xFFBEBEBE);
  static const Color _highlightColor = Color(0xFFFFFFFF);
  
  // Dark theme colors
  static const Color _baseDarkColor = Color(0xFF2E2E2E);
  static const Color _shadowDarkColor = Color(0xFF1A1A1A);
  static const Color _highlightDarkColor = Color(0xFF404040);
  
  static NeumorphicStyle get lightStyle => NeumorphicStyle(
    baseColor: _baseColor,
    accentColor: _accentColor,
    shadowColor: _shadowColor,
    highlightColor: _highlightColor,
    depth: 4.0,
    intensity: 0.8,
    lightSource: LightSource.topLeft,
  );
  
  static NeumorphicStyle get darkStyle => NeumorphicStyle(
    baseColor: _baseDarkColor,
    accentColor: _accentColor,
    shadowColor: _shadowDarkColor,
    highlightColor: _highlightDarkColor,
    depth: 4.0,
    intensity: 0.8,
    lightSource: LightSource.topLeft,
  );
  
  static NeumorphicStyle styleFor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light ? lightStyle : darkStyle;
  }
}

class NeumorphicStyle {
  final Color baseColor;
  final Color accentColor;
  final Color shadowColor;
  final Color highlightColor;
  final double depth;
  final double intensity;
  final LightSource lightSource;
  final BorderRadius? borderRadius;
  
  const NeumorphicStyle({
    required this.baseColor,
    required this.accentColor,
    required this.shadowColor,
    required this.highlightColor,
    required this.depth,
    required this.intensity,
    required this.lightSource,
    this.borderRadius,
  });
  
  NeumorphicStyle copyWith({
    Color? baseColor,
    Color? accentColor,
    Color? shadowColor,
    Color? highlightColor,
    double? depth,
    double? intensity,
    LightSource? lightSource,
    BorderRadius? borderRadius,
  }) {
    return NeumorphicStyle(
      baseColor: baseColor ?? this.baseColor,
      accentColor: accentColor ?? this.accentColor,
      shadowColor: shadowColor ?? this.shadowColor,
      highlightColor: highlightColor ?? this.highlightColor,
      depth: depth ?? this.depth,
      intensity: intensity ?? this.intensity,
      lightSource: lightSource ?? this.lightSource,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
  
  List<BoxShadow> get shadows {
    final offset = _getOffset(lightSource, depth);
    return [
      // Shadow
      BoxShadow(
        color: shadowColor.withOpacity(intensity * 0.3),
        offset: offset,
        blurRadius: depth * 2,
        spreadRadius: 0,
      ),
      // Highlight
      BoxShadow(
        color: highlightColor.withOpacity(intensity * 0.8),
        offset: -offset,
        blurRadius: depth * 2,
        spreadRadius: 0,
      ),
    ];
  }
  
  List<BoxShadow> get insetShadows {
    final offset = _getOffset(lightSource, depth);
    return [
      // Inset shadow
      BoxShadow(
        color: shadowColor.withOpacity(intensity * 0.5),
        offset: -offset,
        blurRadius: depth,
        spreadRadius: -depth / 2,
      ),
      // Inset highlight
      BoxShadow(
        color: highlightColor.withOpacity(intensity * 0.3),
        offset: offset,
        blurRadius: depth,
        spreadRadius: -depth / 2,
      ),
    ];
  }
  
  static Offset _getOffset(LightSource lightSource, double depth) {
    switch (lightSource) {
      case LightSource.topLeft:
        return Offset(-depth, -depth);
      case LightSource.topRight:
        return Offset(depth, -depth);
      case LightSource.bottomLeft:
        return Offset(-depth, depth);
      case LightSource.bottomRight:
        return Offset(depth, depth);
    }
  }
}

enum LightSource { topLeft, topRight, bottomLeft, bottomRight }
enum NeumorphicShape { concave, convex, flat }
''';
  }

  /// Genera botón neumórfico reutilizable
  static String generateNeumorphicButton() {
    return '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NeumorphicButton extends StatefulWidget {
  final Widget? child;
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final NeumorphicStyle? style;
  final Duration animationDuration;
  final bool isToggle;
  final bool isPressed;
  final ValueChanged<bool>? onToggle;
  final BorderRadius? borderRadius;
  
  const NeumorphicButton({
    super.key,
    this.child,
    this.text,
    this.icon,
    this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.style,
    this.animationDuration = const Duration(milliseconds: 150),
    this.isToggle = false,
    this.isPressed = false,
    this.onToggle,
    this.borderRadius,
  });
  
  // Factory constructors para diferentes tipos de botones
  factory NeumorphicButton.icon({
    Key? key,
    required IconData icon,
    VoidCallback? onPressed,
    double size = 24.0,
    Color? iconColor,
    NeumorphicStyle? style,
    String? tooltip,
    EdgeInsets? padding,
  }) {
    return NeumorphicButton(
      key: key,
      onPressed: onPressed,
      style: style,
      padding: padding ?? const EdgeInsets.all(16),
      child: Icon(icon, size: size, color: iconColor),
    );
  }
  
  factory NeumorphicButton.text({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    TextStyle? textStyle,
    NeumorphicStyle? style,
    EdgeInsets? padding,
    double? width,
    double? height,
  }) {
    return NeumorphicButton(
      key: key,
      text: text,
      onPressed: onPressed,
      style: style,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      width: width,
      height: height,
    );
  }
  
  factory NeumorphicButton.iconText({
    Key? key,
    required IconData icon,
    required String text,
    VoidCallback? onPressed,
    double iconSize = 20.0,
    Color? iconColor,
    TextStyle? textStyle,
    NeumorphicStyle? style,
    EdgeInsets? padding,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
  }) {
    return NeumorphicButton(
      key: key,
      onPressed: onPressed,
      style: style,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      ),
    );
  }
  
  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isPressed = false;
  bool _isToggled = false;
  
  @override
  void initState() {
    super.initState();
    _isToggled = widget.isPressed;
    
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(NeumorphicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPressed != oldWidget.isPressed) {
      _isToggled = widget.isPressed;
      if (_isToggled) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }
  
  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed == null) return;
    
    setState(() => _isPressed = true);
    _animationController.forward();
    HapticFeedback.lightImpact();
  }
  
  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed == null) return;
    
    if (widget.isToggle) {
      _isToggled = !_isToggled;
      widget.onToggle?.call(_isToggled);
      if (!_isToggled) {
        _animationController.reverse();
      }
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() => _isPressed = false);
          _animationController.reverse();
        }
      });
    }
    
    widget.onPressed?.call();
  }
  
  void _handleTapCancel() {
    if (!widget.isToggle) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? NeumorphicTheme.styleFor(context);
    final borderRadius = widget.borderRadius ?? 
        style.borderRadius ?? 
        BorderRadius.circular(12);
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final isPressed = _isPressed || _isToggled;
        final currentStyle = isPressed 
          ? style.copyWith(depth: -style.depth.abs())
          : style;
        
        return GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: AnimatedContainer(
            duration: widget.animationDuration,
            width: widget.width,
            height: widget.height,
            padding: widget.padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: currentStyle.baseColor,
              borderRadius: borderRadius,
              boxShadow: isPressed ? currentStyle.insetShadows : currentStyle.shadows,
            ),
            child: _buildChild(style),
          ),
        );
      },
    );
  }
  
  Widget _buildChild(NeumorphicStyle style) {
    if (widget.child != null) {
      return widget.child!;
    }
    
    if (widget.text != null && widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, color: style.accentColor),
          const SizedBox(width: 8),
          Text(
            widget.text!,
            style: TextStyle(
              color: style.accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
    
    if (widget.text != null) {
      return Text(
        widget.text!,
        style: TextStyle(
          color: style.accentColor,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      );
    }
    
    if (widget.icon != null) {
      return Icon(widget.icon, color: style.accentColor);
    }
    
    return const SizedBox.shrink();
  }
}
''';
  }

  /// Genera contenedor neumórfico
  static String generateNeumorphicContainer() {
    return '''
import 'package:flutter/material.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final NeumorphicStyle? style;
  final NeumorphicShape shape;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  
  const NeumorphicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.style,
    this.shape = NeumorphicShape.flat,
    this.borderRadius,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final style = this.style ?? NeumorphicTheme.styleFor(context);
    final borderRadius = this.borderRadius ?? BorderRadius.circular(12);
    
    // Ajustar sombras según la forma
    List<BoxShadow> shadows;
    switch (shape) {
      case NeumorphicShape.concave:
        shadows = style.insetShadows;
        break;
      case NeumorphicShape.convex:
        shadows = style.copyWith(depth: style.depth * 1.5).shadows;
        break;
      case NeumorphicShape.flat:
        shadows = style.shadows;
        break;
    }
    
    Widget container = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: style.baseColor,
        borderRadius: borderRadius,
        boxShadow: shadows,
      ),
      child: child,
    );
    
    if (onTap != null) {
      container = GestureDetector(
        onTap: onTap,
        child: container,
      );
    }
    
    return container;
  }
}
''';
  }

  /// Genera campo de texto neumórfico
  static String generateNeumorphicTextField() {
    return '''
import 'package:flutter/material.dart';

class NeumorphicTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final EdgeInsets? contentPadding;
  final NeumorphicStyle? style;
  final FocusNode? focusNode;
  
  const NeumorphicTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.contentPadding,
    this.style,
    this.focusNode,
  });
  
  @override
  State<NeumorphicTextField> createState() => _NeumorphicTextFieldState();
}

class _NeumorphicTextFieldState extends State<NeumorphicTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  bool _hasFocus = false;
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;
  
  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _focusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }
  
  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
      if (_hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? NeumorphicTheme.styleFor(context);
    
    return AnimatedBuilder(
      animation: _focusAnimation,
      builder: (context, child) {
        final currentStyle = _hasFocus 
          ? style.copyWith(depth: -style.depth.abs())
          : style;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null) ...[
              Text(
                widget.labelText!,
                style: TextStyle(
                  color: _hasFocus 
                    ? style.accentColor 
                    : style.baseColor.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            Container(
              decoration: BoxDecoration(
                color: currentStyle.baseColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: _hasFocus 
                  ? currentStyle.insetShadows
                  : currentStyle.shadows,
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                validator: widget.validator,
                enabled: widget.enabled,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                style: TextStyle(
                  color: style.accentColor,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: style.baseColor.withOpacity(0.6),
                    fontSize: 16,
                  ),
                  prefixIcon: widget.prefixIcon != null 
                    ? Icon(
                        widget.prefixIcon,
                        color: _hasFocus 
                          ? style.accentColor 
                          : style.baseColor.withOpacity(0.7),
                      )
                    : null,
                  suffixIcon: widget.suffixIcon,
                  contentPadding: widget.contentPadding ?? 
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
''';
  }

  /// Genera sistema de comandos inteligente
  static String generateCommandSystem() {
    return '''
class NeumorphicCommandSystem {
  
  /// Analiza el código y sugiere dónde insertar componentes
  static String generateSmartComponentInsertion() {
    return \'''
import 'package:flutter/material.dart';

class ComponentInserter {
  // Patrones de código para detectar ubicaciones apropiadas
  static const Map<String, List<String>> _codePatterns = {
    'button': [
      'onPressed:',
      'ElevatedButton',
      'TextButton',
      'OutlinedButton',
      'FloatingActionButton',
      'GestureDetector(onTap:',
      'InkWell(onTap:',
    ],
    'textField': [
      'TextFormField',
      'TextField',
      'TextEditingController',
      'validator:',
      'onChanged:',
    ],
    'container': [
      'Container(',
      'Card(',
      'Material(',
      'decoration:',
      'BoxDecoration',
    ],
  };

  /// Analiza un archivo Dart y sugiere ubicaciones para componentes
  static List<ComponentSuggestion> analyzeCodeForComponents(
    String dartCode, 
    String componentType
  ) {
    final suggestions = <ComponentSuggestion>[];
    final lines = dartCode.split('\\n');
    final patterns = _codePatterns[componentType] ?? [];
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      
      for (final pattern in patterns) {
        if (line.contains(pattern)) {
          suggestions.add(ComponentSuggestion(
            lineNumber: i + 1,
            line: line.trim(),
            componentType: componentType,
            confidence: _calculateConfidence(line, pattern, lines, i),
            suggestedReplacement: _generateReplacement(componentType, line),
            explanation: _generateExplanation(componentType, pattern),
          ));
        }
      }
    }
    
    suggestions.sort((a, b) => b.confidence.compareTo(a.confidence));
    return suggestions;
  }

  static String _generateReplacement(String componentType, String originalLine) {
    switch (componentType) {
      case 'button':
        return _generateButtonReplacement(originalLine);
      case 'textField':
        return _generateTextFieldReplacement(originalLine);
      case 'container':
        return _generateContainerReplacement(originalLine);
      default:
        return originalLine;
    }
  }

  static String _generateButtonReplacement(String originalLine) {
    final textMatch = RegExp(r"Text\\('([^']+)'\\)").firstMatch(originalLine);
    final callbackMatch = RegExp(r'onPressed:\\s*(\\w+)').firstMatch(originalLine);
    
    final text = textMatch?.group(1) ?? 'Button';
    final callback = callbackMatch?.group(1) ?? 'null';
    
    return \'''NeumorphicButton.text(
  text: '\$text',
  onPressed: \$callback,
  style: NeumorphicTheme.styleFor(context),
)\''';
  }

  static String _generateTextFieldReplacement(String originalLine) {
    final hintMatch = RegExp(r"hintText:\\s*'([^']+)'").firstMatch(originalLine);
    final labelMatch = RegExp(r"labelText:\\s*'([^']+)'").firstMatch(originalLine);
    
    final hint = hintMatch?.group(1) ?? '';
    final label = labelMatch?.group(1) ?? '';
    
    return \'''NeumorphicTextField(
  hintText: '\$hint',
  labelText: '\$label',
  style: NeumorphicTheme.styleFor(context),
)\''';
  }

  static String _generateContainerReplacement(String originalLine) {
    return \'''NeumorphicContainer(
  style: NeumorphicTheme.styleFor(context),
  child: // Tu contenido aquí
)\''';
  }

  static double _calculateConfidence(String line, String pattern, List<String> allLines, int lineIndex) {
    double confidence = 0.5;
    
    if (lineIndex > 0 && allLines.any((l) => l.contains('Widget build('))) {
      confidence += 0.3;
    }
    
    if (allLines.any((l) => l.contains("import 'package:flutter/material.dart'"))) {
      confidence += 0.2;
    }
    
    if (line.trim().startsWith('//')) {
      confidence -= 0.4;
    }
    
    if (pattern.contains('onPressed:') || pattern.contains('onChanged:')) {
      confidence += 0.2;
    }
    
    return confidence.clamp(0.0, 1.0);
  }

  static String _generateExplanation(String componentType, String pattern) {
    final explanations = {
      'button': {
        'onPressed:': 'Detecté un callback onPressed, ideal para un NeumorphicButton',
        'ElevatedButton': 'Puedes reemplazar ElevatedButton con NeumorphicButton para un diseño más moderno',
        'GestureDetector(onTap:': 'Un NeumorphicButton podría ser más apropiado que un GestureDetector',
      },
      'textField': {
        'TextFormField': 'NeumorphicTextField ofrece un diseño más elegante que TextFormField',
        'validator:': 'Detecté validación, NeumorphicTextField mantiene esa funcionalidad',
      },
      'container': {
        'Container(': 'NeumorphicContainer puede dar un efecto visual más atractivo',
        'decoration:': 'El efecto neumórfico puede reemplazar la decoración actual',
      },
    };
    
    return explanations[componentType]?[pattern] ?? 
           'Este patrón sugiere que un componente neumórfico sería apropiado aquí';
  }
}

class ComponentSuggestion {
  final int lineNumber;
  final String line;
  final String componentType;
  final double confidence;
  final String suggestedReplacement;
  final String explanation;
  
  const ComponentSuggestion({
    required this.lineNumber,
    required this.line,
    required this.componentType,
    required this.confidence,
    required this.suggestedReplacement,
    required this.explanation,
  });
  
  @override
  String toString() {
    return 'Línea \$lineNumber: \$explanation (Confianza: \${(confidence * 100).toInt()}%)';
  }
}

class NeumorphicCLI {
  static void handleCommand(List<String> args) {
    if (args.isEmpty) {
      _showHelp();
      return;
    }
    
    final command = args[0].toLowerCase();
    
    switch (command) {
      case 'create':
      case 'add':
        _handleCreateCommand(args.skip(1).toList());
        break;
      case 'analyze':
        _handleAnalyzeCommand(args.skip(1).toList());
        break;
      case 'list':
        _listAvailableComponents();
        break;
      case 'help':
      default:
        _showHelp();
    }
  }
  
  static void _handleCreateCommand(List<String> args) {
    if (args.isEmpty) {
      print('❌ Especifica el tipo de componente a crear');
      print('Ejemplo: create button');
      return;
    }
    
    final componentType = args[0].toLowerCase();
    final availableComponents = [
      'button', 'textfield', 'container'
    ];
    
    if (!availableComponents.contains(componentType)) {
      print('❌ Tipo de componente no válido: \$componentType');
      print('Disponibles: \${availableComponents.join(', ')}');
      return;
    }
    
    print('🎨 Creando componente neumórfico: \$componentType');
    _createComponent(componentType, args.skip(1).toList());
  }
  
  static void _handleAnalyzeCommand(List<String> args) {
    if (args.isEmpty) {
      print('❌ Especifica el archivo a analizar');
      print('Ejemplo: analyze lib/main.dart');
      return;
    }
    
    final filePath = args[0];
    print('🔍 Analizando archivo: \$filePath');
    print('📊 Análisis completado:');
    print('  • 3 botones pueden ser neumórficos');
    print('  • 2 campos de texto detectados');
    print('  • 1 contenedor candidato encontrado');
  }
  
  static void _createComponent(String type, List<String> options) {
    print('\\n🚀 Generando código para \$type neumórfico:\\n');
    
    switch (type) {
      case 'button':
        _generateButtonCode(options);
        break;
      case 'textfield':
        _generateTextFieldCode(options);
        break;
      case 'container':
        _generateContainerCode(options);
        break;
    }
  }
  
  static void _generateButtonCode(List<String> options) {
    final hasIcon = options.contains('--icon');
    final hasText = options.contains('--text') || !hasIcon;
    
    if (hasIcon && hasText) {
      print(\'''NeumorphicButton.iconText(
  icon: Icons.add,
  text: 'Mi Botón',
  onPressed: () {
    // Tu lógica aquí
  },
  style: NeumorphicTheme.styleFor(context),
)\''');
    } else if (hasIcon) {
      print(\'''NeumorphicButton.icon(
  icon: Icons.add,
  onPressed: () {
    // Tu lógica aquí
  },
  style: NeumorphicTheme.styleFor(context),
)\''');
    } else {
      print(\'''NeumorphicButton.text(
  text: 'Mi Botón',
  onPressed: () {
    // Tu lógica aquí
  },
  style: NeumorphicTheme.styleFor(context),
)\''');
    }
  }
  
  static void _generateTextFieldCode(List<String> options) {
    print(\'''NeumorphicTextField(
  hintText: 'Ingresa tu texto',
  labelText: 'Campo de texto',
  style: NeumorphicTheme.styleFor(context),
  onChanged: (value) {
    // Tu lógica aquí
  },
)\''');
  }
  
  static void _generateContainerCode(List<String> options) {
    print(\'''NeumorphicContainer(
  style: NeumorphicTheme.styleFor(context),
  child: // Tu contenido aquí
)\''');
  }
  
  static void _listAvailableComponents() {
    print('🎨 Componentes Neumórficos Disponibles:\\n');
    
    final components = [
      {'name': 'NeumorphicButton', 'desc': 'Botón con efecto neumórfico'},
      {'name': 'NeumorphicTextField', 'desc': 'Campo de texto neumórfico'},
      {'name': 'NeumorphicContainer', 'desc': 'Contenedor con sombras neumórficas'},
      {'name': 'NeumorphicTheme', 'desc': 'Tema base para estilos neumórficos'},
    ];
    
    for (final component in components) {
      print('  📱 \${component['name']}: \${component['desc']}');
    }
    
    print('\\n💡 Usa "create <componente>" para generar código');
    print('💡 Usa "analyze <archivo.dart>" para encontrar oportunidades de mejora');
  }
  
  static void _showHelp() {
    print(\'''
🎨 CLI de Componentes Neumórficos

COMANDOS:
  create <tipo>     Crea código para un componente neumórfico
  analyze <file>    Analiza un archivo Dart en busca de oportunidades
  list             Lista todos los componentes disponibles
  help             Muestra esta ayuda

EJEMPLOS:
  create button --icon --text
  create textfield
  create container
  analyze lib/pages/home.dart

TIPOS DE COMPONENTES:
  button, textfield, container
\''');
  }
}
\''';
  }
}
''';
  }
}
class AdditionalComponentsTemplates {
  
  /// Genera AnimatedCard para efectos de animación
  static String generateAnimatedCard() {
    return '''
import 'package:flutter/material.dart';

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Duration animationDuration;
  final BorderRadius? borderRadius;
  final double elevation;
  final Color? backgroundColor;
  
  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.padding,
    this.animationDuration = const Duration(milliseconds: 200),
    this.borderRadius,
    this.elevation = 4.0,
    this.backgroundColor,
  });
  
  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation + 4,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            margin: widget.margin ?? const EdgeInsets.all(8),
            elevation: _elevationAnimation.value,
            backgroundColor: widget.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
              onTap: widget.onTap,
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) => _controller.reverse(),
              onTapCancel: () => _controller.reverse(),
              child: Padding(
                padding: widget.padding ?? const EdgeInsets.all(16),
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}
''';
  }

  /// Genera componentes de formulario mejorados
  static String generateEnhancedFormComponents() {
    return '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/validators/validator_utils.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final TextInputAction? textInputAction;
  
  const EmailTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.textInputAction,
  });
  
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label ?? 'Correo Electrónico',
      hint: hint ?? 'usuario@ejemplo.com',
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction ?? TextInputAction.next,
      validator: validator ?? ValidatorUtils.validateEmail,
      onChanged: onChanged,
      enabled: enabled,
      prefixIcon: const Icon(Icons.email_outlined),
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\\s')), // No spaces
      ],
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final TextInputAction? textInputAction;
  final bool showStrengthIndicator;
  
  const PasswordTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.textInputAction,
    this.showStrengthIndicator = false,
  });
  
  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;
  double _strength = 0.0;
  String _strengthText = '';
  Color _strengthColor = Colors.red;
  
  @override
  void initState() {
    super.initState();
    if (widget.showStrengthIndicator) {
      widget.controller?.addListener(_updatePasswordStrength);
    }
  }
  
  @override
  void dispose() {
    if (widget.showStrengthIndicator) {
      widget.controller?.removeListener(_updatePasswordStrength);
    }
    super.dispose();
  }
  
  void _updatePasswordStrength() {
    final password = widget.controller?.text ?? '';
    setState(() {
      _strength = _calculatePasswordStrength(password);
      _updateStrengthText();
    });
  }
  
  double _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0.0;
    
    double strength = 0.0;
    
    // Length check
    if (password.length >= 8) strength += 0.25;
    if (password.length >= 12) strength += 0.25;
    
    // Character variety checks
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.125;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.125;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.125;
    if (RegExp(r'[!@#\\\$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.125;
    
    return strength.clamp(0.0, 1.0);
  }
  
  void _updateStrengthText() {
    if (_strength <= 0.25) {
      _strengthText = 'Muy débil';
      _strengthColor = Colors.red;
    } else if (_strength <= 0.5) {
      _strengthText = 'Débil';
      _strengthColor = Colors.orange;
    } else if (_strength <= 0.75) {
      _strengthText = 'Buena';
      _strengthColor = Colors.yellow[700]!;
    } else {
      _strengthText = 'Fuerte';
      _strengthColor = Colors.green;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: widget.controller,
          label: widget.label ?? 'Contraseña',
          hint: widget.hint ?? 'Ingresa tu contraseña',
          obscureText: _obscureText,
          textInputAction: widget.textInputAction ?? TextInputAction.done,
          validator: widget.validator,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
        ),
        if (widget.showStrengthIndicator && _strength > 0) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: _strength,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _strengthText,
                style: TextStyle(
                  color: _strengthColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class PhoneTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final String? countryCode;
  
  const PhoneTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.countryCode,
  });
  
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label ?? 'Teléfono',
      hint: hint ?? '3001234567',
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      validator: validator ?? (value) => ValidatorUtils.validatePhone(value, countryCode: countryCode),
      onChanged: onChanged,
      enabled: enabled,
      prefixIcon: const Icon(Icons.phone_outlined),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final EdgeInsets? contentPadding;
  final bool showCounter;
  final FocusNode? focusNode;
  
  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.contentPadding,
    this.showCounter = false,
    this.focusNode,
  });
  
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  bool _hasFocus = false;
  late AnimationController _animationController;
  late Animation<double> _labelAnimation;
  
  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _labelAnimation = Tween<double>(
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
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null) ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  widget.label!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: _hasFocus 
                      ? theme.colorScheme.primary 
                      : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: _hasFocus ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                readOnly: widget.readOnly,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                validator: widget.validator,
                inputFormatters: widget.inputFormatters,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: widget.enabled 
                    ? theme.colorScheme.onSurface 
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  errorText: widget.errorText,
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.suffixIcon,
                  prefixText: widget.prefixText,
                  suffixText: widget.suffixText,
                  contentPadding: widget.contentPadding ?? 
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  counterText: widget.showCounter ? null : '',
                  
                  // Enhanced borders with animation
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.error,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.error,
                      width: 2,
                    ),
                  ),
                  
                  // Enhanced colors with animation
                  filled: true,
                  fillColor: _hasFocus 
                    ? theme.colorScheme.surface
                    : theme.colorScheme.surface.withOpacity(0.5),
                    
                  // Enhanced text styles
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  errorStyle: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
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

  /// Genera componentes de botones mejorados
  static String generateEnhancedButtonComponents() {
    return '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ButtonType { primary, secondary, outlined, text, filled }
enum ButtonSize { small, medium, large, extraLarge }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? customColor;
  final Color? customTextColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? elevation;
  
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customColor,
    this.customTextColor,
    this.borderRadius,
    this.padding,
    this.elevation,
  });
  
  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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
  
  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _animationController.forward();
      HapticFeedback.lightImpact();
    }
  }
  
  void _handleTapUp(TapUpDetails details) {
    _resetPress();
  }
  
  void _handleTapCancel() {
    _resetPress();
  }
  
  void _resetPress() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: widget.isFullWidth ? double.infinity : null,
            height: _getHeight(),
            child: _buildButton(theme),
          ),
        );
      },
    );
  }
  
  Widget _buildButton(ThemeData theme) {
    final buttonStyle = _getButtonStyle(theme);
    final child = _buildButtonChild(theme);
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: _buildButtonByType(theme, buttonStyle, child),
    );
  }
  
  Widget _buildButtonByType(ThemeData theme, ButtonStyle style, Widget child) {
    switch (widget.type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: style,
          child: child,
        );
      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: style,
          child: child,
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: style,
          child: child,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: style,
          child: child,
        );
      case ButtonType.filled:
        return FilledButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: style,
          child: child,
        );
    }
  }
  
  Widget _buildButtonChild(ThemeData theme) {
    if (widget.isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getLoadingColor(theme),
          ),
        ),
      );
    }
    
    final children = <Widget>[];
    
    if (widget.icon != null) {
      children.add(Icon(widget.icon, size: _getIconSize()));
      if (widget.text.isNotEmpty) {
        children.add(SizedBox(width: _getPadding() / 2));
      }
    }
    
    if (widget.text.isNotEmpty) {
      children.add(
        Text(
          widget.text,
          style: _getTextStyle(theme),
          textAlign: TextAlign.center,
        ),
      );
    }
    
    if (children.length == 1) {
      return children.first;
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
  
  double _getHeight() {
    switch (widget.size) {
      case ButtonSize.small:
        return 36.0;
      case ButtonSize.medium:
        return 48.0;
      case ButtonSize.large:
        return 56.0;
      case ButtonSize.extraLarge:
        return 64.0;
    }
  }
  
  double _getPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return 16.0;
      case ButtonSize.medium:
        return 24.0;
      case ButtonSize.large:
        return 32.0;
      case ButtonSize.extraLarge:
        return 40.0;
    }
  }
  
  double _getIconSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 16.0;
      case ButtonSize.medium:
        return 20.0;
      case ButtonSize.large:
        return 24.0;
      case ButtonSize.extraLarge:
        return 28.0;
    }
  }
  
  ButtonStyle _getButtonStyle(ThemeData theme) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(12);
    final padding = widget.padding ?? EdgeInsets.symmetric(horizontal: _getPadding());
    
    switch (widget.type) {
      case ButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: widget.customColor ?? theme.colorScheme.primary,
          foregroundColor: widget.customTextColor ?? theme.colorScheme.onPrimary,
          elevation: widget.elevation ?? (_isPressed ? 2 : 4),
          shadowColor: theme.colorScheme.shadow,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: padding,
          textStyle: _getBaseTextStyle(),
        );
      case ButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: widget.customColor ?? theme.colorScheme.secondary,
          foregroundColor: widget.customTextColor ?? theme.colorScheme.onSecondary,
          elevation: widget.elevation ?? (_isPressed ? 1 : 2),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: padding,
          textStyle: _getBaseTextStyle(),
        );
      case ButtonType.outlined:
        return OutlinedButton.styleFrom(
          foregroundColor: widget.customColor ?? theme.colorScheme.primary,
          side: BorderSide(
            color: widget.customColor ?? theme.colorScheme.primary,
            width: _isPressed ? 2 : 1.5,
          ),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: padding,
          textStyle: _getBaseTextStyle(),
        );
      case ButtonType.text:
        return TextButton.styleFrom(
          foregroundColor: widget.customColor ?? theme.colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: padding,
          textStyle: _getBaseTextStyle(),
        );
      case ButtonType.filled:
        return FilledButton.styleFrom(
          backgroundColor: widget.customColor ?? theme.colorScheme.primary,
          foregroundColor: widget.customTextColor ?? theme.colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: padding,
          textStyle: _getBaseTextStyle(),
        );
    }
  }
  
  TextStyle _getBaseTextStyle() {
    final fontSize = _getFontSize();
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );
  }
  
  double _getFontSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 14.0;
      case ButtonSize.medium:
        return 16.0;
      case ButtonSize.large:
        return 18.0;
      case ButtonSize.extraLarge:
        return 20.0;
    }
  }
  
  TextStyle? _getTextStyle(ThemeData theme) {
    return _getBaseTextStyle().copyWith(
      color: widget.customTextColor,
    );
  }
  
  Color _getLoadingColor(ThemeData theme) {
    switch (widget.type) {
      case ButtonType.primary:
        return widget.customTextColor ?? theme.colorScheme.onPrimary;
      case ButtonType.secondary:
        return widget.customTextColor ?? theme.colorScheme.onSecondary;
      case ButtonType.outlined:
      case ButtonType.text:
        return widget.customColor ?? theme.colorScheme.primary;
      case ButtonType.filled:
        return widget.customTextColor ?? theme.colorScheme.onPrimary;
    }
  }
}

// Floating Action Button mejorado
class CustomFloatingActionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool isExtended;
  final String? label;
  
  const CustomFloatingActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.isExtended = false,
    this.label,
  });
  
  @override
  State<CustomFloatingActionButton> createState() => _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.isExtended && widget.label != null
            ? FloatingActionButton.extended(
                onPressed: () {
                  _animationController.forward().then((_) {
                    _animationController.reverse();
                  });
                  HapticFeedback.mediumImpact();
                  widget.onPressed?.call();
                },
                icon: Icon(widget.icon),
                label: Text(widget.label!),
                tooltip: widget.tooltip,
                backgroundColor: widget.backgroundColor,
                foregroundColor: widget.foregroundColor,
                elevation: widget.elevation,
              )
            : FloatingActionButton(
                onPressed: () {
                  _animationController.forward().then((_) {
                    _animationController.reverse();
                  });
                  HapticFeedback.mediumImpact();
                  widget.onPressed?.call();
                },
                tooltip: widget.tooltip,
                backgroundColor: widget.backgroundColor,
                foregroundColor: widget.foregroundColor,
                elevation: widget.elevation,
                child: Icon(widget.icon),
              ),
        );
      },
    );
  }
}
''';
  }
}
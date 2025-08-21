class SharedTemplates {
  
  // WIDGETS COMPARTIDOS
  
  /// Genera un CustomButton reutilizable
  static String generateCustomButton() {
    return '''
import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, outlined, text }
enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? customColor;

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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(theme),
    );
  }

  Widget _buildButton(ThemeData theme) {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getButtonStyle(theme),
          child: _buildButtonChild(theme),
        );
      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getSecondaryStyle(theme),
          child: _buildButtonChild(theme, isSecondary: true),
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getOutlinedStyle(theme),
          child: _buildButtonChild(theme, isOutlined: true),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: _getTextStyle(theme),
          child: _buildButtonChild(theme, isText: true),
        );
    }
  }

  Widget _buildButtonChild(
    ThemeData theme, {
    bool isSecondary = false,
    bool isOutlined = false,
    bool isText = false,
  }) {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getLoadingColor(theme, isSecondary, isOutlined, isText),
          ),
        ),
      );
    }

    final children = <Widget>[];
    
    if (icon != null) {
      children.add(Icon(icon, size: _getIconSize()));
      children.add(SizedBox(width: _getPadding() / 2));
    }
    
    children.add(
      Text(
        text,
        style: _getTextStyle(theme, isSecondary, isOutlined, isText),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36.0;
      case ButtonSize.medium:
        return 48.0;
      case ButtonSize.large:
        return 56.0;
    }
  }

  double _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return 12.0;
      case ButtonSize.medium:
        return 16.0;
      case ButtonSize.large:
        return 20.0;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16.0;
      case ButtonSize.medium:
        return 20.0;
      case ButtonSize.large:
        return 24.0;
    }
  }

  ButtonStyle _getButtonStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: customColor ?? theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: 2,
      shadowColor: theme.colorScheme.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: _getPadding()),
    );
  }

  ButtonStyle _getSecondaryStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.secondary,
      foregroundColor: theme.colorScheme.onSecondary,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: _getPadding()),
    );
  }

  ButtonStyle _getOutlinedStyle(ThemeData theme) {
    return OutlinedButton.styleFrom(
      foregroundColor: customColor ?? theme.colorScheme.primary,
      side: BorderSide(
        color: customColor ?? theme.colorScheme.primary,
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: _getPadding()),
    );
  }

  ButtonStyle _getTextStyle(ThemeData theme) {
    return TextButton.styleFrom(
      foregroundColor: customColor ?? theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: _getPadding()),
    );
  }

  Color _getLoadingColor(
    ThemeData theme,
    bool isSecondary,
    bool isOutlined,
    bool isText,
  ) {
    if (isOutlined || isText) {
      return customColor ?? theme.colorScheme.primary;
    }
    return isSecondary 
      ? theme.colorScheme.onSecondary 
      : theme.colorScheme.onPrimary;
  }

  TextStyle? _getTextStyle(
    ThemeData theme,
    bool isSecondary,
    bool isOutlined,
    bool isText,
  ) {
    final baseStyle = theme.textTheme.labelLarge;
    
    switch (size) {
      case ButtonSize.small:
        return baseStyle?.copyWith(fontSize: 14);
      case ButtonSize.medium:
        return baseStyle?.copyWith(fontSize: 16);
      case ButtonSize.large:
        return baseStyle?.copyWith(fontSize: 18);
    }
  }
}
''';
  }

  /// Genera CustomTextField
  static String generateCustomTextField() {
    return '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
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

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
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
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelMedium?.copyWith(
              color: _hasFocus 
                ? theme.colorScheme.primary 
                : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
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
            
            // Border styles
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
                color: theme.colorScheme.outline,
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.5),
                width: 1,
              ),
            ),
            
            // Fill color
            filled: true,
            fillColor: widget.enabled
              ? theme.colorScheme.surface
              : theme.colorScheme.surface.withOpacity(0.5),
              
            // Hint style
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            
            // Error style
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}

// Campos especializados
class PasswordTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const PasswordTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label ?? 'Contraseña',
      hint: widget.hint ?? 'Ingresa tu contraseña',
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      suffixIcon: IconButton(
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const EmailTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label ?? 'Correo electrónico',
      hint: hint ?? 'ejemplo@correo.com',
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: validator ?? _defaultEmailValidator,
      onChanged: onChanged,
      prefixIcon: const Icon(Icons.email_outlined),
    );
  }

  String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es requerido';
    }
    
    final emailRegex = RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    
    return null;
  }
}
''';
  }

  /// Genera LoadingOverlay
  static String generateLoadingOverlay() {
    return '''
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingText;
  final Color? backgroundColor;
  final Color? progressColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingText,
    this.backgroundColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) _buildLoadingOverlay(context),
      ],
    );
  }

  Widget _buildLoadingOverlay(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      color: backgroundColor ?? Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressColor ?? theme.colorScheme.primary,
                ),
              ),
              if (loadingText != null) ...[
                const SizedBox(height: 16),
                Text(
                  loadingText!,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PullToRefreshWidget extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final Color? color;

  const PullToRefreshWidget({
    super.key,
    required this.onRefresh,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? Theme.of(context).colorScheme.primary,
      child: child,
    );
  }
}
''';
  }

  /// Genera CustomCard
  static String generateCustomCard() {
    return '''
import 'package:flutter/material.dart';

enum CardType { elevated, outlined, filled }

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final CardType type;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool showShadow;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.type = CardType.elevated,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.borderRadius = 16.0,
    this.onTap,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget card = Container(
      margin: margin,
      decoration: _getDecoration(theme),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );

    if (type == CardType.elevated && showShadow) {
      return Card(
        elevation: elevation ?? 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: backgroundColor ?? theme.colorScheme.surface,
        margin: margin,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      );
    }

    return card;
  }

  BoxDecoration _getDecoration(ThemeData theme) {
    switch (type) {
      case CardType.elevated:
        return BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: showShadow ? [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        );
      case CardType.outlined:
        return BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? theme.colorScheme.outline,
            width: 1,
          ),
        );
      case CardType.filled:
        return BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(borderRadius),
        );
    }
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomCard(
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (iconColor ?? theme.colorScheme.primary)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor ?? theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 16),
            trailing!,
          ],
        ],
      ),
    );
  }
}
''';
  }

  // MODELOS COMPARTIDOS

  /// Genera BaseModel
  static String generateBaseModel() {
    return '''
import 'package:equatable/equatable.dart';

abstract class BaseModel extends Equatable {
  const BaseModel();

  /// Convierte el modelo a Map para serialización
  Map<String, dynamic> toMap();

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() => toMap();

  @override
  List<Object?> get props => [];
}

abstract class BaseEntity extends Equatable {
  const BaseEntity();

  @override
  List<Object?> get props => [];
}

// Modelo de respuesta genérica de API
class ApiResponse<T> extends BaseModel {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: 200,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode, Map<String, dynamic>? errors}) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode ?? 500,
      errors: errors,
    );
  }

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null && fromJsonT != null 
        ? fromJsonT(json['data']) 
        : json['data'],
      errors: json['errors'],
      statusCode: json['status_code'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data is BaseModel ? (data as BaseModel).toMap() : data,
      'errors': errors,
      'status_code': statusCode,
    };
  }

  @override
  List<Object?> get props => [success, message, data, errors, statusCode];
}

// Modelo de paginación
class PaginatedResponse<T> extends BaseModel {
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      data: (json['data'] as List)
          .map((item) => fromJsonT(item))
          .toList(),
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalItems: json['total_items'] ?? 0,
      hasNextPage: json['has_next_page'] ?? false,
      hasPreviousPage: json['has_previous_page'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'data': data.map((item) => 
        item is BaseModel ? item.toMap() : item).toList(),
      'current_page': currentPage,
      'total_pages': totalPages,
      'total_items': totalItems,
      'has_next_page': hasNextPage,
      'has_previous_page': hasPreviousPage,
    };
  }

  @override
  List<Object?> get props => [
    data, currentPage, totalPages, totalItems, hasNextPage, hasPreviousPage
  ];
}
''';
  }

  /// Genera Result pattern para manejo de errores
  static String generateResultPattern() {
    return '''
import 'package:equatable/equatable.dart';

abstract class Result<T> extends Equatable {
  const Result();

  /// Retorna true si es un resultado exitoso
  bool get isSuccess => this is Success<T>;

  /// Retorna true si es un resultado de error
  bool get isError => this is Error<T>;

  /// Retorna el valor si es exitoso, null si es error
  T? get value => isSuccess ? (this as Success<T>).value : null;

  /// Retorna el error si es un error, null si es exitoso
  Failure? get error => isError ? (this as Error<T>).failure : null;

  /// Ejecuta una función si el resultado es exitoso
  Result<U> map<U>(U Function(T) mapper) {
    return isSuccess 
      ? Success(mapper((this as Success<T>).value))
      : Error((this as Error<T>).failure);
  }

  /// Ejecuta una función async si el resultado es exitoso
  Future<Result<U>> mapAsync<U>(Future<U> Function(T) mapper) async {
    return isSuccess 
      ? Success(await mapper((this as Success<T>).value))
      : Error((this as Error<T>).failure);
  }

  /// Ejecuta una función si el resultado es exitoso (para efectos secundarios)
  Result<T> onSuccess(void Function(T) action) {
    if (isSuccess) {
      action((this as Success<T>).value);
    }
    return this;
  }

  /// Ejecuta una función si el resultado es un error (para efectos secundarios)
  Result<T> onError(void Function(Failure) action) {
    if (isError) {
      action((this as Error<T>).failure);
    }
    return this;
  }

  /// Maneja ambos casos: éxito y error
  U fold<U>(
    U Function(Failure) onError,
    U Function(T) onSuccess,
  ) {
    return isSuccess 
      ? onSuccess((this as Success<T>).value)
      : onError((this as Error<T>).failure);
  }
}

class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'Success(value: \$value)';
}

class Error<T> extends Result<T> {
  final Failure failure;

  const Error(this.failure);

  @override
  List<Object?> get props => [failure];

  @override
  String toString() => 'Error(failure: \$failure)';
}

// Clase base para errores
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'Failure(message: \$message, code: \$code)';
}

// Tipos específicos de errores
class NetworkFailure extends Failure {
  const NetworkFailure(String message, {int? code}) : super(message, code: code);
}

class ServerFailure extends Failure {
  const ServerFailure(String message, {int? code}) : super(message, code: code);
}

class CacheFailure extends Failure {
  const CacheFailure(String message, {int? code}) : super(message, code: code);
}

class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure(
    String message, 
    {int? code, this.fieldErrors}
  ) : super(message, code: code);

  @override
  List<Object?> get props => [message, code, fieldErrors];
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(String message, {int? code}) : super(message, code: code);
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure(String message, {int? code}) : super(message, code: code);
}

class UnknownFailure extends Failure {
  const UnknownFailure(String message, {int? code}) : super(message, code: code);
}

// Extensiones útiles
extension ResultExtensions<T> on Future<Result<T>> {
  /// Maneja errores de excepciones y los convierte a Result
  Future<Result<T>> catchError() async {
    try {
      return await this;
    } catch (e, stackTrace) {
      return Error(UnknownFailure(e.toString()));
    }
  }
}

// Factory methods para crear Results comunes
class Results {
  static Success<T> success<T>(T value) => Success(value);
  
  static Error<T> error<T>(Failure failure) => Error(failure);
  
  static Error<T> networkError<T>(String message, {int? code}) =>
    Error(NetworkFailure(message, code: code));
    
  static Error<T> serverError<T>(String message, {int? code}) =>
    Error(ServerFailure(message, code: code));
    
  static Error<T> validationError<T>(
    String message, 
    {Map<String, List<String>>? fieldErrors}
  ) => Error(ValidationFailure(message, fieldErrors: fieldErrors));
}
''';
  }

  // UTILIDADES

  /// Genera ValidatorUtils
  static String generateValidatorUtils() {
    return '''
class ValidatorUtils {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}\$'
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido';
    }
    
    return null;
  }

  // Password validation
  static String? validatePassword(String? value, {
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = false,
  }) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    
    if (value.length < minLength) {
      return 'La contraseña debe tener al menos \$minLength caracteres';
    }
    
    if (requireUppercase && !RegExp(r'[A-Z]').hasMatch(value)) {
      return 'La contraseña debe contener al menos una letra mayúscula';
    }
    
    if (requireLowercase && !RegExp(r'[a-z]').hasMatch(value)) {
      return 'La contraseña debe contener al menos una letra minúscula';
    }
    
    if (requireNumbers && !RegExp(r'[0-9]').hasMatch(value)) {
      return 'La contraseña debe contener al menos un número';
    }
    
    if (requireSpecialChars && !RegExp(r'[!@#\\\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'La contraseña debe contener al menos un carácter especial';
    }
    
    return null;
  }

  // Password confirmation validation
  static String? validatePasswordConfirmation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'La confirmación de contraseña es requerida';
    }
    
    if (value != password) {
      return 'Las contraseñas no coinciden';
    }
    
    return null;
  }

  // Phone validation
  static String? validatePhone(String? value, {String? countryCode}) {
    if (value == null || value.isEmpty) {
      return 'El número de teléfono es requerido';
    }
    
    // Remove all non-numeric characters
    final numbersOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (countryCode == 'CO') {
      // Colombian phone validation
      if (numbersOnly.length != 10) {
        return 'El número debe tener 10 dígitos';
      }
      if (!numbersOnly.startsWith('3')) {
        return 'El número debe comenzar con 3';
      }
    } else {
      // General phone validation
      if (numbersOnly.length < 7 || numbersOnly.length > 15) {
        return 'Número de teléfono inválido';
      }
    }
    
    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '\${fieldName ?? 'Este campo'} es requerido';
    }
    return null;
  }

  // Length validation
  static String? validateLength(
    String? value, {
    int? minLength,
    int? maxLength,
    String? fieldName,
  }) {
    if (value == null) return null;
    
    if (minLength != null && value.length < minLength) {
      return '\${fieldName ?? 'Este campo'} debe tener al menos \$minLength caracteres';
    }
    
    if (maxLength != null && value.length > maxLength) {
      return '\${fieldName ?? 'Este campo'} no puede tener más de \$maxLength caracteres';
    }
    
    return null;
  }

  // Numeric validation
  static String? validateNumeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;
    
    if (double.tryParse(value) == null) {
      return '\${fieldName ?? 'Este campo'} debe ser un número válido';
    }
    
    return null;
  }

  // Range validation
  static String? validateRange(
    String? value, {
    double? min,
    double? max,
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) return null;
    
    final numValue = double.tryParse(value);
    if (numValue == null) {
      return '\${fieldName ?? 'Este campo'} debe ser un número válido';
    }
    
    if (min != null && numValue < min) {
      return '\${fieldName ?? 'Este campo'} debe ser mayor o igual a \$min';
    }
    
    if (max != null && numValue > max) {
      return '\${fieldName ?? 'Este campo'} debe ser menor o igual a \$max';
    }
    
    return null;
  }

  // Date validation
  static String? validateDate(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;
    
    try {
      DateTime.parse(value);
    } catch (e) {
      return '\${fieldName ?? 'Este campo'} debe ser una fecha válida';
    }
    
    return null;
  }

  // Date range validation
  static String? validateDateRange(
    String? value, {
    DateTime? minDate,
    DateTime? maxDate,
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) return null;
    
    DateTime date;
    try {
      date = DateTime.parse(value);
    } catch (e) {
      return '\${fieldName ?? 'Este campo'} debe ser una fecha válida';
    }
    
    if (minDate != null && date.isBefore(minDate)) {
      return '\${fieldName ?? 'La fecha'} debe ser posterior a \${minDate.toLocal()}';
    }
    
    if (maxDate != null && date.isAfter(maxDate)) {
      return '\${fieldName ?? 'La fecha'} debe ser anterior a \${maxDate.toLocal()}';
    }
    
    return null;
  }

  // URL validation
  static String? validateURL(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;
    
    final urlRegex = RegExp(
      r'^https?://[\\w\\-]+(\\.[\\w\\-]+)+[/#?]?.*\$',
      caseSensitive: false,
    );
    
    if (!urlRegex.hasMatch(value)) {
      return '\${fieldName ?? 'Este campo'} debe ser una URL válida';
    }
    
    return null;
  }

  // Custom regex validation
  static String? validateRegex(
    String? value,
    RegExp regex, {
    String? errorMessage,
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) return null;
    
    if (!regex.hasMatch(value)) {
      return errorMessage ?? '\${fieldName ?? 'Este campo'} tiene un formato inválido';
    }
    
    return null;
  }

  // Combine multiple validators
  static String? combineValidators(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) return result;
    }
    return null;
  }
}

// Extension para usar validadores fácilmente
extension StringValidation on String? {
  String? get validateEmail => ValidatorUtils.validateEmail(this);
  String? get validateRequired => ValidatorUtils.validateRequired(this);
  String? get validateNumeric => ValidatorUtils.validateNumeric(this);
  String? get validateDate => ValidatorUtils.validateDate(this);
  String? get validateURL => ValidatorUtils.validateURL(this);
  
  String? validatePassword({
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = false,
  }) => ValidatorUtils.validatePassword(
    this,
    minLength: minLength,
    requireUppercase: requireUppercase,
    requireLowercase: requireLowercase,
    requireNumbers: requireNumbers,
    requireSpecialChars: requireSpecialChars,
  );
  
  String? validateLength({int? minLength, int? maxLength}) => 
    ValidatorUtils.validateLength(this, minLength: minLength, maxLength: maxLength);
}
''';
  }

  /// Genera FormatUtils
  static String generateFormatUtils() {
    return '''
import 'package:intl/intl.dart';

class FormatUtils {
  // Date formatting
  static String formatDate(DateTime date, {String pattern = 'dd/MM/yyyy'}) {
    return DateFormat(pattern, 'es_ES').format(date);
  }

  static String formatDateTime(DateTime dateTime, {String pattern = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(pattern, 'es_ES').format(dateTime);
  }

  static String formatTime(DateTime time, {String pattern = 'HH:mm'}) {
    return DateFormat(pattern, 'es_ES').format(time);
  }

  // Relative time formatting
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Hace un momento';
    } else if (difference.inMinutes < 60) {
      return 'Hace \${difference.inMinutes} minuto\${difference.inMinutes == 1 ? '' : 's'}';
    } else if (difference.inHours < 24) {
      return 'Hace \${difference.inHours} hora\${difference.inHours == 1 ? '' : 's'}';
    } else if (difference.inDays < 7) {
      return 'Hace \${difference.inDays} día\${difference.inDays == 1 ? '' : 's'}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace \$weeks semana\${weeks == 1 ? '' : 's'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Hace \$months mes\${months == 1 ? '' : 'es'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Hace \$years año\${years == 1 ? '' : 's'}';
    }
  }

  // Currency formatting
  static String formatCurrency(
    double amount, {
    String symbol = '\\\$',
    String locale = 'es_CO',
    int decimalDigits = 0,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  // Number formatting
  static String formatNumber(
    num number, {
    String locale = 'es_ES',
    int? decimalDigits,
  }) {
    final formatter = decimalDigits != null
        ? NumberFormat.decimalPattern(locale)
        : NumberFormat.decimalPattern(locale);
    
    if (decimalDigits != null) {
      formatter.minimumFractionDigits = decimalDigits;
      formatter.maximumFractionDigits = decimalDigits;
    }
    
    return formatter.format(number);
  }

  // Percentage formatting
  static String formatPercentage(double value, {int decimalDigits = 1}) {
    final formatter = NumberFormat.percentPattern('es_ES');
    formatter.minimumFractionDigits = decimalDigits;
    formatter.maximumFractionDigits = decimalDigits;
    return formatter.format(value);
  }

  // Phone formatting
  static String formatPhoneNumber(String phoneNumber, {String? countryCode}) {
    // Remove all non-numeric characters
    final numbersOnly = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (countryCode == 'CO' && numbersOnly.length == 10) {
      // Colombian format: (300) 123-4567
      return '(\${numbersOnly.substring(0, 3)}) \${numbersOnly.substring(3, 6)}-\${numbersOnly.substring(6)}';
    } else if (numbersOnly.length == 10) {
      // US format: (123) 456-7890
      return '(\${numbersOnly.substring(0, 3)}) \${numbersOnly.substring(3, 6)}-\${numbersOnly.substring(6)}';
    } else if (numbersOnly.length == 11) {
      // International format: +1 (123) 456-7890
      return '+\${numbersOnly.substring(0, 1)} (\${numbersOnly.substring(1, 4)}) \${numbersOnly.substring(4, 7)}-\${numbersOnly.substring(7)}';
    }
    
    return phoneNumber; // Return original if format not recognized
  }

  // File size formatting
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '\$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '\${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '\${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '\${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  // Text formatting
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String capitalizeWords(String text) {
    return text.split(' ')
        .map((word) => word.isNotEmpty ? capitalize(word) : word)
        .join(' ');
  }

  static String truncateText(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  // Remove special characters
  static String removeAccents(String text) {
    const withAccents = 'áàäâãåăąéèëêęíìïîįóòöôõøůúùüûųÁÀÄÂÃÅĂĄÉÈËÊĘÍÌÏÎĮÓÒÖÔÕØŮÚÙÜÛŲñÑçÇ';
    const withoutAccents = 'aaaaaaaaaeeeeeiiiiioooooouuuuuAAAAAAAAAEEEEEIIIIIOOOOOOUUUUUnNcC';
    
    String result = text;
    for (int i = 0; i < withAccents.length; i++) {
      result = result.replaceAll(withAccents[i], withoutAccents[i]);
    }
    
    return result;
  }

  static String slugify(String text) {
    return removeAccents(text)
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+\$'), '');
  }

  // Parse functions
  static DateTime? parseDate(String? dateString, {String? format}) {
    if (dateString == null || dateString.isEmpty) return null;
    
    try {
      if (format != null) {
        return DateFormat(format).parse(dateString);
      }
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  static double? parseDouble(String? value) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value.replaceAll(',', '.'));
  }

  static int? parseInt(String? value) {
    if (value == null || value.isEmpty) return null;
    return int.tryParse(value);
  }

  // Duration formatting
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '\${hours.toString().padLeft(2, '0')}:\${minutes.toString().padLeft(2, '0')}:\${seconds.toString().padLeft(2, '0')}';
    } else {
      return '\${minutes.toString().padLeft(2, '0')}:\${seconds.toString().padLeft(2, '0')}';
    }
  }
}

// Extensions for easy formatting
extension DateTimeFormatting on DateTime {
  String get formatted => FormatUtils.formatDate(this);
  String get formattedWithTime => FormatUtils.formatDateTime(this);
  String get timeOnly => FormatUtils.formatTime(this);
  String get relativeTime => FormatUtils.getRelativeTime(this);
}

extension NumberFormatting on num {
  String get formatted => FormatUtils.formatNumber(this);
  String asCurrency({String symbol = '\\\$', int decimalDigits = 0}) =>
      FormatUtils.formatCurrency(toDouble(), symbol: symbol, decimalDigits: decimalDigits);
  String asPercentage({int decimalDigits = 1}) =>
      FormatUtils.formatPercentage(toDouble(), decimalDigits: decimalDigits);
}

extension StringFormatting on String {
  String get capitalized => FormatUtils.capitalize(this);
  String get capitalizedWords => FormatUtils.capitalizeWords(this);
  String truncated(int maxLength, {String suffix = '...'}) =>
      FormatUtils.truncateText(this, maxLength, suffix: suffix);
  String get withoutAccents => FormatUtils.removeAccents(this);
  String get slugified => FormatUtils.slugify(this);
  String get asPhoneNumber => FormatUtils.formatPhoneNumber(this);
}
''';
  }

  /// Genera DateTimeUtils
  static String generateDateTimeUtils() {
    return '''
class DateTimeUtils {
  // Date comparisons
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(date, tomorrow);
  }

  // Date calculations
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  static DateTime endOfWeek(DateTime date) {
    final daysUntilSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysUntilSunday)));
  }

  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59, 999);
  }

  // Age calculation
  static int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    
    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }

  // Working days calculation
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  static bool isWorkingDay(DateTime date, {List<DateTime>? holidays}) {
    if (isWeekend(date)) return false;
    
    if (holidays != null) {
      return !holidays.any((holiday) => isSameDay(date, holiday));
    }
    
    return true;
  }

  static int calculateWorkingDays(DateTime start, DateTime end, {List<DateTime>? holidays}) {
    int workingDays = 0;
    DateTime current = startOfDay(start);
    final endDate = startOfDay(end);
    
    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      if (isWorkingDay(current, holidays: holidays)) {
        workingDays++;
      }
      current = current.add(const Duration(days: 1));
    }
    
    return workingDays;
  }

  // Date ranges
  static List<DateTime> getDatesInRange(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    DateTime current = startOfDay(start);
    final endDate = startOfDay(end);
    
    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }
    
    return dates;
  }

  static List<DateTime> getWeekDatesFromDate(DateTime date) {
    final startOfWeekDate = startOfWeek(date);
    return List.generate(7, (index) => 
        startOfWeekDate.add(Duration(days: index)));
  }

  // Time zones
  static DateTime toLocal(DateTime utcDate) {
    return utcDate.toLocal();
  }

  static DateTime toUtc(DateTime localDate) {
    return localDate.toUtc();
  }

  // Validation
  static bool isValidDate(int year, int month, int day) {
    try {
      DateTime(year, month, day);
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isLeapYear(int year) {
    return (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  }

  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  // Time formatting helpers
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'hace \$years año\${years == 1 ? '' : 's'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'hace \$months mes\${months == 1 ? '' : 'es'}';
    } else if (difference.inDays > 0) {
      return 'hace \${difference.inDays} día\${difference.inDays == 1 ? '' : 's'}';
    } else if (difference.inHours > 0) {
      return 'hace \${difference.inHours} hora\${difference.inHours == 1 ? '' : 's'}';
    } else if (difference.inMinutes > 0) {
      return 'hace \${difference.inMinutes} minuto\${difference.inMinutes == 1 ? '' : 's'}';
    } else {
      return 'hace un momento';
    }
  }

  // Quarter calculations
  static int getQuarter(DateTime date) {
    return ((date.month - 1) / 3).floor() + 1;
  }

  static DateTime startOfQuarter(DateTime date) {
    final quarter = getQuarter(date);
    final startMonth = (quarter - 1) * 3 + 1;
    return DateTime(date.year, startMonth, 1);
  }

  static DateTime endOfQuarter(DateTime date) {
    final quarter = getQuarter(date);
    final endMonth = quarter * 3;
    return endOfMonth(DateTime(date.year, endMonth, 1));
  }

  // Business time calculations
  static DateTime addBusinessDays(DateTime date, int businessDays, {List<DateTime>? holidays}) {
    DateTime result = date;
    int remainingDays = businessDays;
    
    while (remainingDays > 0) {
      result = result.add(const Duration(days: 1));
      if (isWorkingDay(result, holidays: holidays)) {
        remainingDays--;
      }
    }
    
    return result;
  }

  // Parsing helpers
  static DateTime? tryParseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  static DateTime? tryParseCustomFormat(String dateString, String format) {
    try {
      // This would need intl package for full implementation
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}

// Extensions for DateTime
extension DateTimeExtensions on DateTime {
  bool get isToday => DateTimeUtils.isToday(this);
  bool get isYesterday => DateTimeUtils.isYesterday(this);
  bool get isTomorrow => DateTimeUtils.isTomorrow(this);
  bool get isWeekend => DateTimeUtils.isWeekend(this);
  
  DateTime get startOfDay => DateTimeUtils.startOfDay(this);
  DateTime get endOfDay => DateTimeUtils.endOfDay(this);
  DateTime get startOfWeek => DateTimeUtils.startOfWeek(this);
  DateTime get endOfWeek => DateTimeUtils.endOfWeek(this);
  DateTime get startOfMonth => DateTimeUtils.startOfMonth(this);
  DateTime get endOfMonth => DateTimeUtils.endOfMonth(this);
  DateTime get startOfYear => DateTimeUtils.startOfYear(this);
  DateTime get endOfYear => DateTimeUtils.endOfYear(this);
  
  String get timeAgo => DateTimeUtils.getTimeAgo(this);
  int get quarter => DateTimeUtils.getQuarter(this);
  
  bool isSameDayAs(DateTime other) => DateTimeUtils.isSameDay(this, other);
  int ageFrom(DateTime birthDate) => DateTimeUtils.calculateAge(birthDate);
}
''';
  }

  /// Actualizar app_generator para usar las nuevas plantillas
  static String generateUpdatedAppGenerator() {
    return '''
// Agregar al final de la clase AppGenerator

  /// Genera carpeta shared completa con widgets y utilidades
  Future<void> generateSharedFolder(Map<String, dynamic> options) async {
    ConsoleUtils.info('🔧 Generando carpeta shared con implementaciones...');
    
    await _createDirectoryStructure([
      'lib/shared/widgets/buttons',
      'lib/shared/widgets/forms',
      'lib/shared/widgets/cards',
      'lib/shared/widgets/loading',
      'lib/shared/models',
      'lib/shared/utils/validators',
      'lib/shared/utils/formatters',
      'lib/shared/utils/datetime',
      'lib/shared/services',
    ]);

    final sharedTemplates = SharedTemplates();

    // Generar widgets
    await FileUtils.writeFile(
      'lib/shared/widgets/buttons/custom_button.dart',
      sharedTemplates.generateCustomButton(),
    );

    await FileUtils.writeFile(
      'lib/shared/widgets/forms/custom_text_field.dart',
      sharedTemplates.generateCustomTextField(),
    );

    await FileUtils.writeFile(
      'lib/shared/widgets/loading/loading_overlay.dart',
      sharedTemplates.generateLoadingOverlay(),
    );

    await FileUtils.writeFile(
      'lib/shared/widgets/cards/custom_card.dart',
      sharedTemplates.generateCustomCard(),
    );

    // Generar modelos
    await FileUtils.writeFile(
      'lib/shared/models/base_model.dart',
      sharedTemplates.generateBaseModel(),
    );

    await FileUtils.writeFile(
      'lib/shared/models/result.dart',
      sharedTemplates.generateResultPattern(),
    );

    // Generar utilidades
    await FileUtils.writeFile(
      'lib/shared/utils/validators/validator_utils.dart',
      sharedTemplates.generateValidatorUtils(),
    );

    await FileUtils.writeFile(
      'lib/shared/utils/formatters/format_utils.dart',
      sharedTemplates.generateFormatUtils(),
    );

    await FileUtils.writeFile(
      'lib/shared/utils/datetime/datetime_utils.dart',
      sharedTemplates.generateDateTimeUtils(),
    );

''';
  }
}

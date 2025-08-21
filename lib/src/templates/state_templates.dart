class StateTemplates {
  
  /// Genera archivo de estado para AuthCubit
  static String generateAuthState() {
    return '''
part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  
  AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  
  AuthError(this.message);
}
''';
  }

  /// Genera archivo de estado para OnboardingCubit
  static String generateOnboardingState() {
    return '''
part of 'onboarding_cubit.dart';

abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingPageChanged extends OnboardingState {
  final int page;
  
  OnboardingPageChanged(this.page);
}

class OnboardingCompleted extends OnboardingState {}

class OnboardingError extends OnboardingState {
  final String message;
  
  OnboardingError(this.message);
}
''';
  }

  /// Genera archivo de estado para HomeCubit
  static String generateHomeState() {
    return '''
part of 'home_cubit.dart';

class HomeState {
  final bool isLoading;
  final int unreadNotifications;
  final String userName;
  final String? error;

  const HomeState({
    required this.isLoading,
    required this.unreadNotifications,
    required this.userName,
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    int? unreadNotifications,
    String? userName,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      userName: userName ?? this.userName,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeState &&
        other.isLoading == isLoading &&
        other.unreadNotifications == unreadNotifications &&
        other.userName == userName &&
        other.error == error;
  }

  @override
  int get hashCode {
    return Object.hash(isLoading, unreadNotifications, userName, error);
  }
}
''';
  }

  /// Genera archivo de estado genérico
  static String generateGenericState(String featureName) {
    final pascalCase = _pascalCase(featureName);
    
    return '''
part of '${featureName}_cubit.dart';

abstract class ${pascalCase}State {}

class ${pascalCase}Initial extends ${pascalCase}State {}

class ${pascalCase}Loading extends ${pascalCase}State {}

class ${pascalCase}Success extends ${pascalCase}State {
  final dynamic data;
  
  ${pascalCase}Success(this.data);
}

class ${pascalCase}Error extends ${pascalCase}State {
  final String message;
  
  ${pascalCase}Error(this.message);
}
''';
  }

  static String _pascalCase(String text) {
    return text.split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join('');
  }
}
import 'package:args/args.dart';

/// Options for configuring the code generation
class GeneratorOptions {
  final bool cleanArchitecture;
  final bool includeAnimations;
  final bool includeRecovery;
  final bool includeNotifications;
  final bool useDio;
  final bool includeInterceptors;
  final bool includeSecureStorage;
  final bool includeConnectivity;
  final String navigationType;
  final int tabsCount;
  final int pagesCount;
  final int animationDuration;
  final String baseUrl;

  const GeneratorOptions({
    this.cleanArchitecture = true,
    this.includeAnimations = true,
    this.includeRecovery = true,
    this.includeNotifications = true,
    this.useDio = true,
    this.includeInterceptors = true,
    this.includeSecureStorage = true,
    this.includeConnectivity = true,
    this.navigationType = 'bottom',
    this.tabsCount = 3,
    this.pagesCount = 3,
    this.animationDuration = 3,
    this.baseUrl = 'https://api.example.com',
  });

  /// Create options from command line arguments
  factory GeneratorOptions.fromArgResults(ArgResults results) {
    return GeneratorOptions(
      cleanArchitecture: results['clean-architecture'] as bool? ?? true,
      includeAnimations: results['include-animations'] as bool? ?? true,
      includeRecovery: results['include-recovery'] as bool? ?? true,
      includeNotifications: results['include-notifications'] as bool? ?? true,
      useDio: results['use-dio'] as bool? ?? true,
      includeInterceptors: results['include-interceptors'] as bool? ?? true,
      includeSecureStorage: results['include-secure-storage'] as bool? ?? true,
      includeConnectivity: results['include-connectivity'] as bool? ?? true,
      navigationType: results['navigation-type'] as String? ?? 'bottom',
      tabsCount: int.tryParse(results['tabs-count'] as String? ?? '3') ?? 3,
      pagesCount: int.tryParse(results['pages-count'] as String? ?? '3') ?? 3,
      animationDuration: int.tryParse(results['animation-duration'] as String? ?? '3') ?? 3,
      baseUrl: results['base-url'] as String? ?? 'https://api.example.com',
    );
  }

  /// Create options from a map
  factory GeneratorOptions.fromMap(Map<String, dynamic> map) {
    return GeneratorOptions(
      cleanArchitecture: map['clean-architecture'] as bool? ?? true,
      includeAnimations: map['include-animations'] as bool? ?? true,
      includeRecovery: map['include-recovery'] as bool? ?? true,
      includeNotifications: map['include-notifications'] as bool? ?? true,
      useDio: map['use-dio'] as bool? ?? true,
      includeInterceptors: map['include-interceptors'] as bool? ?? true,
      includeSecureStorage: map['include-secure-storage'] as bool? ?? true,
      includeConnectivity: map['include-connectivity'] as bool? ?? true,
      navigationType: map['navigation-type'] as String? ?? 'bottom',
      tabsCount: map['tabs-count'] as int? ?? 3,
      pagesCount: map['pages-count'] as int? ?? 3,
      animationDuration: map['animation-duration'] as int? ?? 3,
      baseUrl: map['base-url'] as String? ?? 'https://api.example.com',
    );
  }

  /// Convert to map for easy passing to generators
  Map<String, dynamic> toMap() {
    return {
      'clean-architecture': cleanArchitecture,
      'include-animations': includeAnimations,
      'include-recovery': includeRecovery,
      'include-notifications': includeNotifications,
      'use-dio': useDio,
      'include-interceptors': includeInterceptors,
      'include-secure-storage': includeSecureStorage,
      'include-connectivity': includeConnectivity,
      'navigation-type': navigationType,
      'tabs-count': tabsCount,
      'pages-count': pagesCount,
      'animation-duration': animationDuration,
      'base-url': baseUrl,
    };
  }

  /// Create a copy with different values
  GeneratorOptions copyWith({
    bool? cleanArchitecture,
    bool? includeAnimations,
    bool? includeRecovery,
    bool? includeNotifications,
    bool? useDio,
    bool? includeInterceptors,
    bool? includeSecureStorage,
    bool? includeConnectivity,
    String? navigationType,
    int? tabsCount,
    int? pagesCount,
    int? animationDuration,
    String? baseUrl,
  }) {
    return GeneratorOptions(
      cleanArchitecture: cleanArchitecture ?? this.cleanArchitecture,
      includeAnimations: includeAnimations ?? this.includeAnimations,
      includeRecovery: includeRecovery ?? this.includeRecovery,
      includeNotifications: includeNotifications ?? this.includeNotifications,
      useDio: useDio ?? this.useDio,
      includeInterceptors: includeInterceptors ?? this.includeInterceptors,
      includeSecureStorage: includeSecureStorage ?? this.includeSecureStorage,
      includeConnectivity: includeConnectivity ?? this.includeConnectivity,
      navigationType: navigationType ?? this.navigationType,
      tabsCount: tabsCount ?? this.tabsCount,
      pagesCount: pagesCount ?? this.pagesCount,
      animationDuration: animationDuration ?? this.animationDuration,
      baseUrl: baseUrl ?? this.baseUrl,
    );
  }

  @override
  String toString() {
    return 'GeneratorOptions('
        'cleanArchitecture: $cleanArchitecture, '
        'includeAnimations: $includeAnimations, '
        'navigationType: $navigationType, '
        'tabsCount: $tabsCount'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GeneratorOptions &&
        other.cleanArchitecture == cleanArchitecture &&
        other.includeAnimations == includeAnimations &&
        other.includeRecovery == includeRecovery &&
        other.includeNotifications == includeNotifications &&
        other.useDio == useDio &&
        other.includeInterceptors == includeInterceptors &&
        other.includeSecureStorage == includeSecureStorage &&
        other.includeConnectivity == includeConnectivity &&
        other.navigationType == navigationType &&
        other.tabsCount == tabsCount &&
        other.pagesCount == pagesCount &&
        other.animationDuration == animationDuration &&
        other.baseUrl == baseUrl;
  }

  @override
  int get hashCode {
    return Object.hash(
      cleanArchitecture,
      includeAnimations,
      includeRecovery,
      includeNotifications,
      useDio,
      includeInterceptors,
      includeSecureStorage,
      includeConnectivity,
      navigationType,
      tabsCount,
      pagesCount,
      animationDuration,
      baseUrl,
    );
  }
}
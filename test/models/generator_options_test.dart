import 'package:test/test.dart';
import 'package:flutter_app_base_generator/src/models/generator_options.dart';
import 'package:args/args.dart';

void main() {
  group('GeneratorOptions', () {
    test('creates default options', () {
      const options = GeneratorOptions();
      
      expect(options.cleanArchitecture, isTrue);
      expect(options.includeAnimations, isTrue);
      expect(options.navigationType, equals('bottom'));
      expect(options.tabsCount, equals(3));
    });

    test('creates options from map', () {
      final map = {
        'clean-architecture': false,
        'navigation-type': 'sidebar',
        'tabs-count': 5,
      };
      
      final options = GeneratorOptions.fromMap(map);
      
      expect(options.cleanArchitecture, isFalse);
      expect(options.navigationType, equals('sidebar'));
      expect(options.tabsCount, equals(5));
    });

    test('creates options from ArgResults', () {
      final parser = ArgParser()
        ..addFlag('clean-architecture', defaultsTo: true)
        ..addFlag('include-animations', defaultsTo: true)
        ..addFlag('include-recovery', defaultsTo: true)
        ..addFlag('include-notifications', defaultsTo: true)
        ..addFlag('use-dio', defaultsTo: true)
        ..addFlag('include-interceptors', defaultsTo: true)
        ..addFlag('include-secure-storage', defaultsTo: true)
        ..addFlag('include-connectivity', defaultsTo: true)
        ..addOption('navigation-type', defaultsTo: 'bottom')
        ..addOption('tabs-count', defaultsTo: '3')
        ..addOption('pages-count', defaultsTo: '3')
        ..addOption('animation-duration', defaultsTo: '3')
        ..addOption('base-url', defaultsTo: 'https://api.example.com');
      
      final results = parser.parse(['--no-clean-architecture', '--no-include-animations', '--navigation-type=sidebar', '--tabs-count=4']);
      final options = GeneratorOptions.fromArgResults(results);
      
      expect(options.cleanArchitecture, isFalse);
      expect(options.includeAnimations, isFalse);
      expect(options.navigationType, equals('sidebar'));
      expect(options.tabsCount, equals(4));
    });

    test('converts to map correctly', () {
      const options = GeneratorOptions(
        cleanArchitecture: false,
        navigationType: 'sidebar',
        tabsCount: 5,
      );
      
      final map = options.toMap();
      
      expect(map['clean-architecture'], isFalse);
      expect(map['navigation-type'], equals('sidebar'));
      expect(map['tabs-count'], equals(5));
    });

    test('copyWith creates new instance with updated values', () {
      const original = GeneratorOptions(cleanArchitecture: true, tabsCount: 3);
      final updated = original.copyWith(cleanArchitecture: false, tabsCount: 5);
      
      expect(updated.cleanArchitecture, isFalse);
      expect(updated.tabsCount, equals(5));
      expect(updated.includeAnimations, equals(original.includeAnimations)); // unchanged
    });

    test('equality works correctly', () {
      const options1 = GeneratorOptions(cleanArchitecture: true, tabsCount: 3);
      const options2 = GeneratorOptions(cleanArchitecture: true, tabsCount: 3);
      const options3 = GeneratorOptions(cleanArchitecture: false, tabsCount: 3);
      
      expect(options1, equals(options2));
      expect(options1, isNot(equals(options3)));
    });

    test('toString provides useful output', () {
      const options = GeneratorOptions(
        cleanArchitecture: true,
        navigationType: 'bottom',
        tabsCount: 3,
      );
      
      final string = options.toString();
      expect(string, contains('cleanArchitecture: true'));
      expect(string, contains('navigationType: bottom'));
      expect(string, contains('tabsCount: 3'));
    });
  });
}
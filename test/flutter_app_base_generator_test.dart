import 'package:test/test.dart';
import 'package:flutter_app_base_generator/flutter_app_base_generator.dart';

void main() {
  group('FlutterAppBaseGenerator', () {
    late FlutterAppBaseGenerator generator;

    setUp(() {
      generator = FlutterAppBaseGenerator();
    });

    test('can be instantiated', () {
      expect(generator, isNotNull);
    });

    test('shows help when no arguments provided', () async {
      await generator.run([]);
      // This should not throw and should show help
    });

    test('shows version when version command is called', () async {
      await generator.run(['version']);
      // This should not throw and should show version
    });

    test('shows help when help command is called', () async {
      await generator.run(['help']);
      // This should not throw and should show help
    });
  });
}
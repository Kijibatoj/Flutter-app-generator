#!/usr/bin/env dart

import 'dart:io';
import 'package:flutter_app_base_generator/flutter_app_base_generator.dart';

Future<void> main(List<String> arguments) async {
  try {
    final generator = FlutterAppBaseGenerator();
    await generator.run(arguments);
  } catch (e) {
    stderr.writeln('Error: $e');
    exit(1);
  }
}
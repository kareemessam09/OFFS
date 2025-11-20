import 'package:flutter/material.dart';
import 'package:offs/app.dart';
import 'package:offs/core/di/injection.dart';

void main() {
  configureDependencies();
  runApp(const OffsApp());
}

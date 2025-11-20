import 'package:flutter/material.dart';
import 'package:offs/config/theme/app_theme.dart';
import 'package:offs/config/routes/app_router.dart';

class OffsApp extends StatelessWidget {
  const OffsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offs',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.dashboard,
    );
  }
}

import 'package:book_time/core/bloc/bloc_providers.dart';
import 'package:book_time/core/navigation/presentation/widgets/app_router.dart';
import 'package:book_time/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocProviders.setup();
  runApp(
    MaterialApp.router(
      title: 'Book Time',
      theme: AppTheme.dark,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    ),
  );
}

// ignore_for_file: public_member_api_docs
/// Office Kit AI+ — AI-powered desktop companion (hackathon build).
/// Windows-first, 1440×900 optimized, Riverpod + GoRouter.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/services/ai_service.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: OfficeKitApp()));
}

class OfficeKitApp extends ConsumerWidget {
  const OfficeKitApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp.router(
      title: 'Office Kit AI+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: settings.accent, primary: settings.accent),
      ),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      routerConfig: appRouter,
    );
  }
}

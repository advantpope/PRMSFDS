import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'app_theme.dart';

// Theme mode provider
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// Theme data provider
final themeDataProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeModeProvider);

  return themeMode == ThemeMode.dark ? AppTheme.darkTheme : AppTheme.lightTheme;
});

// Brightness provider
final brightnessProvider = Provider<Brightness>((ref) {
  final themeMode = ref.watch(themeModeProvider);

  return themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
});

// Theme toggle provider
// final themeToggleProvider = Provider<void>((ref) {
//   final currentMode = ref.read(themeModeProvider);
//   ref.read(themeModeProvider.notifier).state = currentMode == ThemeMode.light
//       ? ThemeMode.dark
//       : ThemeMode.light;
// });

final themeToggleProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((
  ref,
) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void toggle() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

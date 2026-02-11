import 'package:flutter/material.dart';
import 'package:siemb/helpers/bible_shared_pref.dart';
import 'package:siemb/theme/app_theme.dart';

/// Provides [ThemeMode], [setThemeMode], [theme] and [darkTheme] for the app.
class AppThemeMode extends InheritedWidget {
  const AppThemeMode({
    super.key,
    required this.themeMode,
    required this.setThemeMode,
    required this.theme,
    required this.darkTheme,
    required super.child,
  });

  final ThemeMode themeMode;
  final void Function(ThemeMode mode) setThemeMode;
  final ThemeData theme;
  final ThemeData darkTheme;

  static AppThemeMode? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppThemeMode>();
  }

  @override
  bool updateShouldNotify(AppThemeMode old) {
    return themeMode != old.themeMode || theme != old.theme || darkTheme != old.darkTheme;
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> addSharedBibleVersion(String? version) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('bibleVersion', version ?? 'nvi');
}

Future<void> addSharedBibleFontSize(String? size) async {
  final prefs = await SharedPreferences.getInstance();
  final s = size ?? "Med";
  switch (s) {
    case "Big" :
      prefs.setDouble('bibleTitleSize', 20.0);
      prefs.setDouble('bibleFontSize', 18.0);
      break;
    case "Med" :
      prefs.setDouble('bibleTitleSize', 18.0);
      prefs.setDouble('bibleFontSize', 16.0);
      break;
    case "Little" :
      prefs.setDouble('bibleTitleSize', 16.0);
      prefs.setDouble('bibleFontSize', 14.0);
      break;
    default:
      prefs.setDouble('bibleTitleSize', 18.0);
      prefs.setDouble('bibleFontSize', 16.0);
  }
}

Future<String> getSharedBibleVersion() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('bibleVersion') ?? 'nvi';
}

Future<double> getSharedBibleTitleFontSize() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('bibleTitleSize') ?? 18.0;
}

Future<double> getSharedBibleFontSize() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('bibleFontSize') ?? 16.0;
}


// Shared Pref. da área principal.

Future<void> addSharedAppVersion(String? version) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('version', version ?? 'nvi');
}

Future<void> addSharedAppFontSize(String? size) async {
  final prefs = await SharedPreferences.getInstance();
  final s = size ?? "Med";
  switch (s) {
    case "Big" :
      prefs.setDouble('titleSize', 20);
      prefs.setDouble('fontSize', 18);
      break;
    case "Med" :
      prefs.setDouble('titleSize', 18);
      prefs.setDouble('fontSize', 16);
      break;
    case "Little" :
      prefs.setDouble('titleSize', 16);
      prefs.setDouble('fontSize', 14);
      break;
    default:
      prefs.setDouble('titleSize', 18);
      prefs.setDouble('fontSize', 16);
  }
}

Future<String> getSharedAppVersion() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('version') ?? 'nvi';
}

Future<double> getSharedAppTitleFontSize() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('titleSize') ?? 18.0;
}

Future<double> getSharedAppFontSize() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('fontSize') ?? 16.0;
}

// Idioma do app (interface)
Future<void> setSharedAppLanguage(String lang) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('appLanguage', lang);
}

Future<String> getSharedAppLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('appLanguage') ?? 'pt-BR';
}

/// Retorna o [Locale] salvo (pt-BR ou en-US). Usado no boot/restart do app.
Future<Locale> getAppLocaleAsync() async {
  final lang = await getSharedAppLanguage();
  return lang == 'en-US' ? const Locale('en', 'US') : const Locale('pt', 'BR');
}

// Theme mode (Material 3 dark mode switch)
Future<void> setSharedThemeMode(String mode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('themeMode', mode);
}

Future<String> getSharedThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('themeMode') ?? 'system';
}
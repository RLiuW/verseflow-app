import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:siemb/helpers/bible_shared_pref.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/screens/login/login_screen.dart';
import 'package:siemb/models/user_model.dart';
import 'package:siemb/theme/app_theme.dart';
import 'package:siemb/theme/theme_mode_provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, st) {
    debugPrint('Firebase.initializeApp error: $e');
    debugPrint('Stack trace: $st');
    try {
      await Firebase.initializeApp();
    } catch (e2) {
      debugPrint('Firebase.initializeApp fallback error: $e2');
      rethrow;
    }
  }
  runApp(Phoenix(child: const _AppLoader()));
}

/// Carrega o locale salvo e monta [MyApp]. Ao usar [Phoenix.rebirth], esta
/// árvore é reconstruída e o idioma é relido das preferências.
class _AppLoader extends StatelessWidget {
  const _AppLoader();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Locale>(
      future: getAppLocaleAsync(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(Brightness.light),
            darkTheme: buildAppTheme(Brightness.dark),
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return MyApp(locale: snap.data!);
      },
    );
  }
}

class MyApp extends StatefulWidget {
  final Locale locale;
  const MyApp({super.key, required this.locale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final mode = await getSharedThemeMode();
    if (!mounted) return;
    setState(() {
      _themeMode = switch (mode) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        _ => ThemeMode.system,
      };
    });
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
    setSharedThemeMode(mode == ThemeMode.dark
        ? 'dark'
        : mode == ThemeMode.light
            ? 'light'
            : 'system');
  }

  @override
  Widget build(BuildContext context) {
    final theme = buildAppTheme(Brightness.light);
    final darkTheme = buildAppTheme(Brightness.dark);
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: AppThemeMode(
        themeMode: _themeMode,
        setThemeMode: _setThemeMode,
        theme: theme,
        darkTheme: darkTheme,
        child: MaterialApp(
          title: 'VerseFlow',
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          themeMode: _themeMode,
          locale: widget.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const LoginScreen(),
        ),
      ),
    );
  }
}

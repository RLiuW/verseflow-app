import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:siemb/helpers/bible_shared_pref.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/screens/home/home_screen.dart';
import 'package:siemb/theme/theme_mode_provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin{
  late AnimationController _animationController;
  double sliderValue = 0;
  String groupValue = "";
  String version = "nvi";
  double titleSize = 18.0;
  double fontSize = 16.0;
  String appLanguage = 'pt-BR';


  @override
  void initState() {
    _animationController = AnimationController(duration: const Duration(seconds: 3), vsync: this, upperBound: pi * 2);
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {
        if (_animationController.status == AnimationStatus.completed) {
          _animationController.repeat();
        }
      });
    });
    _getSharedData().then((_) {
      if (mounted) setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeModeProvider = AppThemeMode.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_outlined),
          onPressed: () => _closeSettings(),
        ),
        title: Text(l10n.settingsTitle),
        actions: <Widget>[
          AnimatedBuilder(
            animation: _animationController,
            child: SizedBox(
              height: 40,
              width: 40,
              child: Image.asset("images/settings_bk_grey.png"),
            ),
            builder: (BuildContext context, Widget? child) {
              return Transform.rotate(
                angle: _animationController.value,
                child: child!,
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Column(
                  children: <Widget>[
                    if (themeModeProvider != null) _buildThemeModeTile(context, themeModeProvider),
                    _createVersionSliding(context, l10n),
                    _createFontSlider(context, l10n),
                    const SizedBox(height: 20),
                    _createLanguageSelector(context, l10n),
                    const SizedBox(height: 40),
                    OverflowBar(
                          children: <Widget>[
                            TextButton(
                                onPressed: (){_saveDefaultSettings(context);},
                                child: Text(l10n.defaultButton),
                            ),
                      FilledButton(
                        onPressed: () => _saveSettings(context, version),
                        child: Text(l10n.save),
                      ),
                    ],
                  ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeModeTile(BuildContext context, AppThemeMode provider) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = provider.themeMode == ThemeMode.dark;
    final isLight = provider.themeMode == ThemeMode.light;
    final isSystem = provider.themeMode == ThemeMode.system;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.dark_mode_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(l10n.themeTitle, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.themeLight),
                  selected: isLight,
                  onSelected: (_) => provider.setThemeMode(ThemeMode.light),
                ),
                ChoiceChip(
                  label: Text(l10n.themeDark),
                  selected: isDark,
                  onSelected: (_) => provider.setThemeMode(ThemeMode.dark),
                ),
                ChoiceChip(
                  label: Text(l10n.themeSystem),
                  selected: isSystem,
                  onSelected: (_) => provider.setThemeMode(ThemeMode.system),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _createFontSlider(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Column(
        children: <Widget> [
          const SizedBox( height: 30,),
          Text(l10n.bibleVersionLabel,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: onSurface,
            ),
          ),
          const SizedBox( height: 15,),
          CupertinoSegmentedControl<String>(
              selectedColor: theme.colorScheme.primaryContainer,
              unselectedColor: theme.colorScheme.surfaceContainerHighest,
              borderColor: theme.colorScheme.outline,
              onValueChanged: (T){
                setState(() {
                  version = T;
                });
              },
              groupValue: version,
              children: <String, Widget> {
                'aa' : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text ("Almeida Atualizada",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: onSurface),
                  ),
                ),
                "acf" : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text ("Almeida Corrigida e Fiel",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: onSurface),
                  ),
                ),
                "nvi" : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text ("Nova Versão Internacional",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: onSurface),
                  ),
                )
              }
          ),
          const SizedBox( height: 30,)
        ]
    );
  }

  Widget _createVersionSliding(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Column(
        children: <Widget> [
          const SizedBox( height: 30,),
          Text(l10n.fontSizeLabel,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: onSurface,
            ),
          ),
          const SizedBox( height: 15,),
          Text(l10n.fontSizeLegend,
            style: theme.textTheme.bodyMedium?.copyWith(color: onSurface),
          ),
          const SizedBox( height: 10,),
          CupertinoSlider(
              min: 0,
              max: 50,
              divisions: 2,
              value: sliderValue,
              onChanged: (double val){
                setState(() {
                  sliderValue = val;
                });
              }

          ),
          const SizedBox( height: 30,)
        ]
    );
  }

  Future _getSharedData() async {
    version = await getSharedAppVersion();
    titleSize =  await getSharedAppTitleFontSize();
    fontSize =  await getSharedAppFontSize();
    appLanguage = await getSharedAppLanguage();
    if (titleSize == 20){
      sliderValue = 50;
    }else if( titleSize == 18){
      sliderValue = 25;
    }else sliderValue = 0;
  }

  String size (){
    if (sliderValue == 50) {
      return "Big";
    } else if (sliderValue == 25){
      return "Med";
    } else if (sliderValue == 0){
      return "Little";
    }
    return "Med";
  }
  Future _saveSettings(BuildContext context, String version) async {
    await addSharedAppVersion(version);
    await addSharedAppFontSize(size());
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.settingsSaved)));
  }
  Future _saveDefaultSettings(BuildContext context) async {
    await addSharedAppVersion(null);
    await addSharedAppFontSize(null);
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.settingsReset)));
  }

  Widget _createLanguageSelector(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.interfaceLanguageTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: appLanguage,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: [
            DropdownMenuItem(value: 'pt-BR', child: Text(l10n.languagePtBr)),
            DropdownMenuItem(value: 'en-US', child: Text(l10n.languageEnUs)),
          ],
          onChanged: (val) async {
            if (val == null) return;
            setState(() => appLanguage = val);
            await setSharedAppLanguage(val);
            if (!context.mounted) return;
            final l = AppLocalizations.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.restartAppMessage)),
            );
            _showRestartDialog(context, l);
          },
        ),
      ],
    );
  }

  void _showRestartDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.restartConfirmTitle),
        content: Text(l10n.restartConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.no),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Future.delayed(const Duration(milliseconds: 300));
              if (!context.mounted) return;
              Phoenix.rebirth(context);
            },
            child: Text(l10n.yes),
          ),
        ],
      ),
    );
  }

  void _closeSettings() {
    //Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return const HomeScreen();}));
  }




}


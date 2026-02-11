import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siemb/helpers/bible_shared_pref.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/screens/bible/bible_home.dart';

class BibleSettings extends StatefulWidget {
  const BibleSettings({super.key});

  @override
  _BibleSettingsState createState() => _BibleSettingsState();
}

class _BibleSettingsState extends State<BibleSettings> with TickerProviderStateMixin{
  late AnimationController _animationController;
  double sliderValue = 0;
  String groupValue = "";
  String version = "nvi";
  double titleSize = 18.0;
  double fontSize = 16.0;


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
    _getSharedData();

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_outlined),
          onPressed: () => _closeSettings(),
        ),
        title: Text(l10n.bibleSettingsTitle),
        actions: [
          AnimatedBuilder(
            animation: _animationController,
            child: SizedBox(
              height: 40,
              width: 40,
              child: Image.asset("images/settings_bk.png"),
            ),
            builder: (BuildContext context, Widget? child) {
              return Transform.rotate(
                angle: _animationController.value,
                child: child ?? const SizedBox.shrink(),
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
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  children: [
                    _createVersionSliding(),
                    _createFontSlider(),
                    const SizedBox(height: 40),
                    OverflowBar(
                      children: [
                        TextButton(
                          onPressed: () => _saveDefaultSettings(context),
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
  Widget _createFontSlider(){
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        const SizedBox(height: 30),
        Text(l10n.bibleVersionLabel, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface)),
        const SizedBox(height: 15),
        CupertinoSegmentedControl<String>(
          selectedColor: theme.colorScheme.primaryContainer,
          unselectedColor: theme.colorScheme.surfaceContainerHighest,
          borderColor: theme.colorScheme.outline,
          onValueChanged: (value) => setState(() => version = value),
          groupValue: version,
          children: const {
            'aa': Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("Almeida Atualizada", textAlign: TextAlign.center),
            ),
            'acf': Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("Almeida Corrigida e Fiel", textAlign: TextAlign.center),
            ),
            'nvi': Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("Nova Versão Internacional", textAlign: TextAlign.center),
            ),
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _createVersionSliding(){
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        const SizedBox(height: 30),
        Text(l10n.fontSizeLabel, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface)),
        const SizedBox(height: 15),
        Text(l10n.fontSizeLegend, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface)),
        const SizedBox(height: 10),
        CupertinoSlider(
          min: 0,
          max: 50,
          divisions: 2,
          value: sliderValue,
          onChanged: (double val) => setState(() => sliderValue = val),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Future<void> _getSharedData() async {
    version = await getSharedBibleVersion();
    titleSize =  await getSharedBibleTitleFontSize();
    fontSize =  await getSharedBibleFontSize();
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
  Future<void> _saveSettings(BuildContext context, String version) async {
    await addSharedBibleVersion(version);
    await addSharedBibleFontSize(size());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Dados personalizados salvos!"), behavior: SnackBarBehavior.floating),
    );
  }
  Future<void> _saveDefaultSettings(BuildContext context) async {
    await addSharedBibleVersion(null);
    await addSharedBibleFontSize(null);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Dados resetados!"), behavior: SnackBarBehavior.floating),
    );
  }

  void _closeSettings() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BibleHome(initialPage: 0)));
  }




}


import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:siemb/helpers/bible_shared_pref.dart';
import 'package:siemb/l10n/app_localizations.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  String appLanguage = 'pt-BR';

  @override
  void initState() {
    super.initState();
    getSharedAppLanguage().then((v) {
      if (mounted) setState(() => appLanguage = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.settingsTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: scheme.onSurface,
          ),
        ),
        backgroundColor: scheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _buildLanguageSelector(context, l10n),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.interfaceLanguageTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: scheme.onSurface,
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.restartAppMessage)),
            );
            _showRestartDialog(context, l10n);
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
}

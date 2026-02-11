import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:siemb/helpers/bible_shared_pref.dart';
import 'package:siemb/helpers/warning_type.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/widgets/glass_card.dart';

class AdminWarningCard extends StatefulWidget {

  final DocumentSnapshot snapshot;

  const AdminWarningCard(this.snapshot, {super.key});

  @override
  _AdminWarningCardState createState() => _AdminWarningCardState();
}

class _AdminWarningCardState extends State<AdminWarningCard> {
  String tipo = '';
  String date = '';
  String msg = '';
  double titleSize = 16.0;
  double fontSize = 14.0;
  TextEditingController textController = TextEditingController();
  Map<String, dynamic> warnData = {};
  final FirebaseFirestore _data = FirebaseFirestore.instance;
  String dropdownValue = 'Ensaio';
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }
  String _dateLocale(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return '${locale.languageCode}_${locale.countryCode ?? (locale.languageCode == 'pt' ? 'BR' : 'US')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeStr = _dateLocale(context);
    tipo = (widget.snapshot.data() as Map<String, dynamic>?)?["tipo"]?.toString() ?? "";
    return FutureBuilder(
      future: _getSharedData(),
      builder: (context, snapshot) {
        return Column(
          children: [
            GestureDetector(
              onTap: () => _callEditWarning(context),
              child: GlassCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: warningType(tipo),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${l10n.type}: $tipo",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${l10n.date}: ${formatData(localeStr)}",
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            (widget.snapshot.data() as Map<String, dynamic>?)?["mensagem"]?.toString() ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  void _callEditWarning(BuildContext context) {
    final data = (widget.snapshot.data() as Map<String, dynamic>?);
    textController.text = data?["mensagem"]?.toString() ?? "";
    String aux = data?["tipo"]?.toString() ?? "";
    const dropDownItems = ['Ensaio', 'Horário', 'Música', 'Pedido'];

    if (aux.contains("Ensaio")) {
      dropdownValue = dropDownItems[0];
    } else if (aux.contains("Horário")) {
      dropdownValue = dropDownItems[1];
    } else if (aux.contains("Música")) {
      dropdownValue = dropDownItems[2];
    } else if (aux.contains("Pedido")) {
      dropdownValue = dropDownItems[3];
    }

    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            l10n.editWarning,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down_rounded, size: 25),
                      elevation: 2,
                      dropdownColor: scheme.surfaceContainerHigh,
                      style: TextStyle(color: scheme.primary, fontSize: 16),
                      items: dropDownItems.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue == null) return;
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${l10n.messageLabel}: ",
                      style: theme.textTheme.titleSmall?.copyWith(color: scheme.onSurface),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: textController,
                      maxLines: 6,
                      style: TextStyle(color: scheme.onSurface),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: scheme.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _deleteData(context);
              },
              child: Text(l10n.delete),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _saveData(context);
              },
              child: Text(l10n.save),
            ),
          ],
        ));
  }

  String formatData(String localeStr) {
    final data = (widget.snapshot.data() as Map<String, dynamic>?);
    if (data != null && data['data'] != null) {
      final timestamp = data['data'] as Timestamp?;
      if (timestamp != null) {
        return DateFormat(DateFormat.YEAR_MONTH_DAY, localeStr).format(timestamp.toDate().toUtc());
      }
    }
    return "";
  }

  void _deleteData(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            l10n.deleteThisWarning,
            style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                const SizedBox(width: 60),
                Icon(Icons.delete_rounded, size: 40, color: scheme.onSurface),
                const SizedBox(width: 20),
                Icon(Icons.warning_amber_outlined, color: scheme.error, size: 40),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                final docID = widget.snapshot.id;
                await _data.collection("avisos").doc(docID).delete();
                _showToast(l10n.warningDeletedSuccess);
                if (!context.mounted) return;
                setState(() {});
                Navigator.pop(ctx);
              },
              child: Text(l10n.confirm),
            ),
          ],
        ));
  }

  Future<void> _saveData(BuildContext context) async {
    final data = (widget.snapshot.data() as Map<String, dynamic>?);
    if (textController.text.isEmpty) {
      warnData = {
        "mensagem": data?["mensagem"]?.toString() ?? "",
        "tipo": dropdownValue,
      };
    } else {
      warnData = {
        "mensagem": textController.text,
        "tipo": dropdownValue,
      };
    }

    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            l10n.saveEditWarning,
            style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                const SizedBox(width: 60),
                Icon(Icons.save_rounded, size: 40, color: scheme.onSurface),
                const SizedBox(width: 20),
                Icon(Icons.warning_amber_outlined, color: scheme.error, size: 40),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                final docID = widget.snapshot.id;
                await _data.collection("avisos").doc(docID).update(warnData);
                _showToast(l10n.warningEditedSuccess);
                if (!context.mounted) return;
                setState(() {});
                Navigator.pop(ctx);
              },
              child: Text(l10n.confirm),
            ),
          ],
        ));
  }

  Future _getSharedData() async {
    //version = await getSharedBibleVersion();
    titleSize =  await getSharedAppTitleFontSize();
    fontSize =  await getSharedAppFontSize();
  }
  void _showToast(String toastText) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) => Opacity(opacity: value, child: child),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outlined, color: Theme.of(context).colorScheme.onInverseSurface),
              const SizedBox(width: 12),
              Expanded(child: Text(toastText)),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }


  }



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siemb/helpers/bible_shared_pref.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/widgets/glass_card.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminMessageCard extends StatefulWidget {


  final DocumentSnapshot snapshot;
  const AdminMessageCard(this.snapshot, {super.key});

  @override
  _AdminMessageCardState createState() => _AdminMessageCardState();
}

class _AdminMessageCardState extends State<AdminMessageCard> {
  String title = '';
  dynamic date;
  String msg = '';
  TextEditingController textController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  Map<String, dynamic> msgData = {};
  double titleSize = 18;
  double fontSize = 16;
  late FToast fToast;

  final FirebaseFirestore _data = FirebaseFirestore.instance;

  @override
  void initState() {

    _getSharedData();
    fToast = FToast();
    fToast.init(context);
    initializeDateFormatting();

    super.initState();
  }


  String _dateLocale(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return '${locale.languageCode}_${locale.countryCode ?? (locale.languageCode == 'pt' ? 'BR' : 'US')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeStr = _dateLocale(context);
    return FutureBuilder(
      future: _getSharedData(),
      builder: (context, snapshot2) {
        final titulo = (widget.snapshot.data() as Map<String, dynamic>?)?["título"]?.toString() ?? "";
        return GestureDetector(
          onTap: () => _callEditMessage(context),
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Image.asset("images/message_type.png", height: 40, width: 40),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${l10n.title}: $titulo",
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
                        ((widget.snapshot.data() as Map<String, dynamic>?)?["mensagem"]?.toString() ?? "").replaceAll("<v>", "").replaceAll("<vv>", ""),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
        );
      }
    );
  }

  void _callEditMessage(BuildContext context) {
    final data = (widget.snapshot.data() as Map<String, dynamic>?);
    textController.text = data?["mensagem"]?.toString() ?? "";
    titleController.text = data?["título"]?.toString() ?? "";
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            l10n.editMessage,
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
                    Text(
                      "${l10n.title}: ",
                      style: theme.textTheme.titleSmall?.copyWith(color: scheme.onSurface),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      maxLines: 1,
                      controller: titleController,
                      style: TextStyle(color: scheme.onSurface),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: scheme.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${l10n.messageLabel}: ",
                      style: theme.textTheme.titleSmall?.copyWith(color: scheme.onSurface),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      maxLines: 10,
                      controller: textController,
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


  Future _getSharedData() async {
    //version = await getSharedBibleVersion();
    titleSize =  await getSharedAppTitleFontSize();
    fontSize =  await getSharedAppFontSize();
  }

  void _deleteData(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            l10n.deleteThisMessage,
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
                Icon(Icons.message, color: scheme.error, size: 40),
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
                await _data.collection("mensagens").doc(docID).delete();
                _showToast(l10n.messageDeletedSuccess);
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
    msgData = {
      "mensagem" : textController.text,
      "título" : titleController.text,
    };

    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            l10n.saveEditMessage,
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
                Icon(Icons.message, color: scheme.error, size: 40),
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
                await _data.collection("mensagens").doc(docID).update(msgData);
                _showToast(l10n.messageEditedSuccess);
                if (!context.mounted) return;
                setState(() {});
                Navigator.pop(ctx);
              },
              child: Text(l10n.confirm),
            ),
          ],
        ));
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

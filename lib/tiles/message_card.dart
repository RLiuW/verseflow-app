import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:siemb/helpers/bible_shared_pref.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/tiles/message_full.dart';
import 'package:siemb/widgets/glass_card.dart';

class MessageCard extends StatefulWidget {


  final DocumentSnapshot snapshot;
  const MessageCard(this.snapshot, {super.key});

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  String title = '';
  String date = '';
  String msg = '';

  double titleSize = 18.0;
  double fontSize = 16.0;

  @override
  void initState() {
    _getSharedData();
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
    final titulo = (widget.snapshot.data() as Map<String, dynamic>?)?["título"]?.toString() ?? "";
    final formatted = formatData(localeStr);
    title = "${l10n.title}: $titulo";
    final heroTag = 'message_${widget.snapshot.id}';
    return FutureBuilder(
      future: _getSharedData(),
      builder: (context, snapshot2) {
        return GestureDetector(
          onTap: () => _callMessageFull(context, formatted),
          child: Hero(
            tag: heroTag,
            child: GlassCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${l10n.title}: $titulo",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${l10n.date}: $formatted",
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _callMessageFull(BuildContext context, String formattedDate) {
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => MessageFull(
        title,
        formattedDate,
        (widget.snapshot.data() as Map<String, dynamic>?)?["mensagem"]?.toString() ?? "",
        titleSize,
        fontSize,
        widget.snapshot.id,
      ))
    );
  }

  String formatData(String localeStr) {
    final data = widget.snapshot.data() as Map<String, dynamic>?;
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
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:siemb/helpers/bible_shared_pref.dart';
import 'package:siemb/helpers/warning_type.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/tiles/warning_full.dart';
import 'package:siemb/widgets/glass_card.dart';

class WarningCard extends StatefulWidget {

  final DocumentSnapshot snapshot;
  const WarningCard(this.snapshot, {super.key});

  @override
  _WarningCardState createState() => _WarningCardState();
}

class _WarningCardState extends State<WarningCard> {
  String tipo = '';
  String date = '';
  String msg = '';
  double titleSize = 18.0;
  double fontSize = 16.0;

  @override
  void initState() {
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
    final tipoVal = (widget.snapshot.data() as Map<String, dynamic>?)?["tipo"]?.toString() ?? "";
    tipo = "$tipoVal";
    msg = (widget.snapshot.data() as Map<String, dynamic>?)?["mensagem"]?.toString() ?? "";
    final formatted = formatData(localeStr);
    final heroTag = 'warning_${widget.snapshot.id}';
    return FutureBuilder(
      future: _getSharedData(),
      builder: (context, snapshot) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTap: () => _callWarningFull(context, "${l10n.type}: $tipoVal", formatted),
              child: Hero(
                tag: heroTag,
                child: GlassCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: warningType(tipoVal),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${l10n.type}: $tipoVal",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${l10n.date}: $formatted",
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              msg,
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
            );
          },
        );
      },
    );
  }

  void _callWarningFull(BuildContext context, String tipoLabel, String formattedDate) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WarningFull(
          tipoLabel,
          formattedDate,
          msg,
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

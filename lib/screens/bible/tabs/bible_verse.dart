import 'package:flutter/material.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/screens/bible/display_verses.dart';



class BibleVerse extends StatelessWidget {

  final AsyncSnapshot<dynamic> snapshot;
  final int? chapterIndex;
  final int? bookIndex;
  final String? bookName;
  final double titleSize;
  const BibleVerse(this.snapshot, this.chapterIndex, this.bookIndex, this.bookName, this.titleSize, {super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final name = bookName ?? '';
    final chapIdx = chapterIndex;
    final bookIdx = bookIndex;
    if (name.isEmpty || bookIdx == null || chapIdx == null) {
      return Center(
        child: Text(
          l10n.chooseBookAndChapterFirst,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Column(
      children: [
          const SizedBox(height: 5,),
          Container(
            alignment: Alignment.center,
            child: Text("$name ${chapIdx + 1}" ,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),

          ),
          Expanded(
            child: createGridView(context, snapshot, bookIdx, chapIdx, titleSize),
          ),
        ],
      );
  }

Widget createGridView(BuildContext context, AsyncSnapshot snapshot, int bookIndex, int chapterIndex, double titleSize) {
  final l10n = AppLocalizations.of(context);
  final theme = Theme.of(context);
  final onSurface = theme.colorScheme.onSurface;
  final data = snapshot.data;
  if (data == null || data is! List || bookIndex < 0 || bookIndex >= data.length) {
    return Center(child: Text(l10n.chooseBookFirst, style: theme.textTheme.bodyLarge?.copyWith(fontSize: titleSize, color: onSurface)));
  }
  final chaps = data[bookIndex]['chapters'];
  if (chaps == null || chapterIndex < 0 || chapterIndex >= (chaps is List ? chaps.length : 0)) {
    return Center(child: Text(l10n.chooseChapterFirst, style: theme.textTheme.bodyLarge?.copyWith(fontSize: titleSize, color: onSurface)));
  }
  final values = chaps is List ? chaps[chapterIndex] : <dynamic>[];
  final list = values is List ? values : <dynamic>[];
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:  4),
    itemCount: list.length,
    scrollDirection: Axis.vertical,
    itemBuilder: (BuildContext context, int index) {
      return GestureDetector(
        onTap: () => _displayVerse(context, index),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              child: Text('${index+1}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: titleSize,
                  color: onSurface,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
  void _displayVerse(BuildContext context, int index) {
    final chapIdx = chapterIndex ?? 0;
    final bookIdx = bookIndex ?? 0;
    final bName = bookName ?? '';
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      final bibleData = (snapshot.data is List) ? (snapshot.data as List<dynamic>) : <dynamic>[];
      return DisplayVerses(bibleData, chapIdx, bookIdx, index, bName);
    }));
  }
}

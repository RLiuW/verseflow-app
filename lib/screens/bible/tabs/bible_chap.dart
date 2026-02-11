import 'package:flutter/material.dart';
import 'package:siemb/l10n/app_localizations.dart';
import '../bible_home.dart';

class BibleChapter extends StatelessWidget {

  final AsyncSnapshot<dynamic> snapshot;
  final int? bookIndex;
  final String? bookName;
  final double titleSize;

  const BibleChapter(this.snapshot, this.bookIndex, this.bookName, this.titleSize, {super.key});


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final name = bookName ?? '';
    return (name.isEmpty || bookIndex == null) ? Container(child: Center(child: Text(l10n.chooseBookFirst,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: onSurface),),),) : Container(
      child: Column(
        children: [
          const SizedBox(height: 5,),
          Container(
            child: Text(name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: onSurface,
              ),
            ),
          ),
          Expanded(
            child: createGridView(context, snapshot)
          ),
        ],
      ),
    );
  }
  void _callVerse(BuildContext context, index) {
    int i = index;
    final idx = bookIndex ?? 0;
    final bName = bookName ?? '';
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) { return BibleHome(initialPage: 2,
      bookIndex: idx, chapterIndex: i, bookName: bName, );}));
  }

  Widget createGridView(BuildContext context, AsyncSnapshot snapshot){
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final data = snapshot.data;
    final idx = bookIndex ?? -1;
    if (data == null || data is! List || idx < 0 || idx >= data.length) {
      return Center(child: Text(l10n.chooseBookFirst, style: theme.textTheme.bodyLarge?.copyWith(fontSize: titleSize, color: onSurface)));
    }
    final book = data[idx];
    final chapters = (book is Map ? book['chapters'] : null) as List?;
    final values = chapters ?? <dynamic>[];
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:  4),
      itemCount: values.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => _callVerse(context, index),
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

}

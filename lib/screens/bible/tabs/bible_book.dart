import 'package:flutter/material.dart';
import 'package:siemb/screens/bible/bible_home.dart';




class BibleBook extends StatelessWidget {

  final AsyncSnapshot<dynamic> snapshot;
  final double fontSize;
  final String name = '';
  final String abbrev = '';

  const BibleBook(this.snapshot, this.fontSize, {super.key});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;
    return ListView.builder(
      itemCount: 66,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => _callChapter(context, index),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 60,
                    child: Text('${snapshot.data[index]['name']}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: fontSize,
                        color: onSurface,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: primary,
                          border: Border.all(color: primary),
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Text(
                        '${snapshot.data[index]['abbrev']}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: fontSize,
                            color: onPrimary,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  void _callChapter(BuildContext context, int index) {
    final bookIdx = index;
    final bookName = snapshot.data[index]['name']?.toString() ?? '';
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return BibleHome(
        initialPage: 1,
        bookIndex: bookIdx,
        bookName: bookName,
      );
    }));
  }
}
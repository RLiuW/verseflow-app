import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:siemb/helpers/bible_shared_pref.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/screens/bible/bible_home.dart';



class DisplayVerses extends StatefulWidget {

  final List<dynamic> bibleData;
  final int chapterIndex;
  final int bookIndex;
  final int verseIndex;
  final String bookName;


  const DisplayVerses(this.bibleData, this.chapterIndex, this.bookIndex, this.verseIndex, this.bookName, {super.key});

  @override
  _DisplayVersesState createState() => _DisplayVersesState();
}


class _DisplayVersesState extends State<DisplayVerses> {

  String version = '';
  double titleSize = 16.0;
  double fontSize = 14.0;
  late ItemScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ItemScrollController();
    _getSharedData();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => scrollTo());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget createListView(BuildContext context) {
    final data = widget.bibleData;
    if (data.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final bookIdx = widget.bookIndex.clamp(0, data.length - 1);
    final book = data[bookIdx];
    final chaps = (book is Map ? book['chapters'] : null) as List?;
    if (chaps == null || widget.chapterIndex < 0 || widget.chapterIndex >= chaps.length) {
      final l10n = AppLocalizations.of(context);
      final theme = Theme.of(context);
      return Center(
        child: Text(
          l10n.invalidChapter,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: titleSize,
            color: theme.colorScheme.onSurface,
          ),
        ),
      );
    }
    final values = chaps[widget.chapterIndex];
    final list = values is List ? values : <dynamic>[];
    return ScrollablePositionedList.builder(
      itemScrollController: _scrollController,
      itemCount: list.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {},
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                child: _display(context, index, widget.bookIndex, widget.chapterIndex),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _display(BuildContext context, int i, int bookIdx, int chapIdx) {
    final data = widget.bibleData;
    if (data.isEmpty || bookIdx < 0 || bookIdx >= data.length) {
      return const SizedBox();
    }
    final book = data[bookIdx];
    final chaps = (book is Map ? book['chapters'] : null) as List?;
    if (chaps == null || chapIdx < 0 || chapIdx >= chaps.length) {
      return const SizedBox();
    }
    final verses = chaps[chapIdx];
    final verseList = verses is List ? verses : <dynamic>[];
    final text = i >= 0 && i < verseList.length ? verseList[i].toString() : '';
    final theme = Theme.of(context);
      final onSurface = theme.colorScheme.onSurface;
      return Row(
        children: [
          Text('${i + 1}  ',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: onSurface,
            ),
          ),
          Flexible(
            child: Text(text,
              textAlign: TextAlign.justify,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: titleSize,
                color: onSurface,
              ),
            ),
          ),
        ],
      );

  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: FutureBuilder(
            future: _getSharedData(),
            builder: (BuildContext context,snapshot) {
              return Column(
                children: [
                  const SizedBox(height: 15,),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        // Expanded(
                        //     flex: 2,
                        //     child: IconButton(
                        //         icon: Icon(Icons.arrow_back, size: 20), onPressed: () {
                        //       _closeVerses(context);
                        //     })
                        // ),
                        Expanded(
                            flex: 10,
                            child: IconButton(
                                icon: const Icon(Icons.chevron_left), onPressed: () {
                              _lastChapter(context);
                            })
                        ),
                        Expanded(
                          flex: 10,
                          child: GestureDetector(
                            onTap: () {
                              _closeVerses(context);
                            },
                            child: Builder(
                            builder: (ctx) {
                              final theme = Theme.of(ctx);
                              final onSurface = theme.colorScheme.onSurface;
                              return Text(
                                "${widget.bookName} ${widget.chapterIndex + 1} ${version.toString().toUpperCase()}",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                  color: onSurface,
                                ),
                              );
                            },
                          ),
                          ),
                        ),
                        Expanded(
                            flex: 10,
                            child: IconButton(
                                icon: const Icon(Icons.chevron_right), onPressed: () {
                              _nextChapter(context);
                            })
                        ),
                      ],
                    ),

                  ),
                  Expanded(
                      child: createListView(context)
                  ),
                ],
              );
            }
        ),
      );
    }

  void scrollTo() async =>  _scrollController.scrollTo(
      index: widget.verseIndex, duration: const Duration(seconds: 1),  curve: Curves.easeInOutCubic);

    void _lastChapter(BuildContext context) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return DisplayVerses(widget.bibleData,
                widget.chapterIndex == 0 ? widget.chapterIndex : widget
                    .chapterIndex - 1, widget.bookIndex, 0,
                widget.bookName,);
          }));
    }

    void _nextChapter(BuildContext context) {
      final data = widget.bibleData;
      final book = data[widget.bookIndex];
      final chaps = (book is Map ? book['chapters'] : null) as List?;
      final values = (chaps != null && widget.chapterIndex >= 0 && widget.chapterIndex < chaps.length)
          ? chaps[widget.chapterIndex]
          : <dynamic>[];
      final maxChaptersLen = values is List ? values.length : 0;

      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return DisplayVerses(widget.bibleData,
                widget.chapterIndex == maxChaptersLen
                    ? widget.chapterIndex
                    : widget.chapterIndex + 1, widget.bookIndex,
                0, widget.bookName,);
          }));
    }


  void _closeVerses(BuildContext context){

    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return const BibleHome(initialPage: 0,);
        }));
  }


  Future _getSharedData() async {
    version = await getSharedBibleVersion();
    titleSize =  await getSharedBibleTitleFontSize();
    fontSize =  await getSharedBibleFontSize();
  }
}
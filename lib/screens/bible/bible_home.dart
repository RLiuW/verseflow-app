import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siemb/helpers/bible_shared_pref.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/screens/bible/bible_search_delegate.dart';
import 'package:siemb/screens/bible/bible_settings.dart';
import 'package:siemb/screens/bible/tabs/bible_book.dart';
import 'package:siemb/screens/bible/tabs/bible_chap.dart';
import 'package:siemb/screens/bible/tabs/bible_verse.dart';
import 'package:siemb/screens/home/home_screen.dart';


class BibleHome extends StatefulWidget {


final int initialPage;
final int? bookIndex;
final int? chapterIndex;
final String? bookName;

const BibleHome({super.key, this.bookName, this.bookIndex, this.chapterIndex, this.initialPage = 0});

  @override
  _BibleHome createState() => _BibleHome();
}

class _BibleHome extends State<BibleHome>
    with SingleTickerProviderStateMixin {

  late TabController tabController;

  String chap = '';
  String verse = '';
  String abbrev = '';
  String version = 'nvi';
  double titleSize = 18.0;
  double fontSize = 16.0;


  @override
  void initState() {
    _getSharedData();
    tabController = TabController(vsync: this, length: 3, initialIndex: widget.initialPage);

    _bibleData();

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sliver(),


    );
  }


  Widget _sliver(){
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          collapsedHeight: 85.0,
          expandedHeight: 150.0,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _closeBible(),
          ),
          floating: true,
          snap: true,
          elevation: 0,
          title: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context);
              final textTheme = Theme.of(context).textTheme;
              final mainStyle = textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              );
              final verseFlowStyle = textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              );
              return Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '${l10n.bibleSacred} ', style: mainStyle),
                    TextSpan(text: 'VerseFlow', style: verseFlowStyle),
                  ],
                ),
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: BibleSearchDelegate(),
                );
              },
              icon: const Icon(Icons.search_outlined, size: 25),
            ),
            IconButton(
              onPressed: () => _callBibleSettings(),
              icon: const Icon(Icons.settings_outlined, size: 25),
            ),
          ],
          flexibleSpace: Stack(
              children: <Widget> [
                Positioned.fill(
                    child: Image.asset("images/bk_sliver.jpg",
                      fit: BoxFit.cover,
                    )
                ),
                FlexibleSpaceBar(
                  title: Container(
                    alignment: Alignment.bottomCenter,
                    child: const Row(
                      children: [
                        SizedBox(width: 70),
                        Icon(Icons.menu_book_outlined, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ]
          ),
        ),

        SliverList (
          delegate: SliverChildListDelegate (
                   [
                     _bibleBody(),


           ]
          ),
        ),
        SliverFillRemaining(
          child:
          FutureBuilder(
            future: _getSharedData(),
            builder: (context, snapshot) {
              return FutureBuilder<dynamic>(
                future: _bibleData(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return _tabView(snapshot, widget.chapterIndex, widget.bookIndex, widget.bookName);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            },
          )
        ),
      ],

    );
  }

  Widget _bibleBody(){
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return TabBar(
          controller: tabController,
          tabs: [
            Tab(child: Text(l10n.bookTab)),
            Tab(child: Text(l10n.chapterTab)),
            Tab(child: Text(l10n.verseTab)),
          ],
        );
      },
    );
  }

  Widget _tabView(AsyncSnapshot<dynamic> snapshot, int? chapterIndex, int? bookIndex, String? bookName){
    return TabBarView(
        controller: tabController,
        children: [
        BibleBook(snapshot, titleSize),
        BibleChapter(snapshot, bookIndex, bookName, titleSize),
        BibleVerse(snapshot, chapterIndex, bookIndex, bookName, titleSize),
        ]
    );
  }

  // Widget _flexBar() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           flex: 30,
  //           child: Text(
  //             "Livro",
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 13,
  //                 color: Colors.white),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 20,
  //           child: Text(
  //             "Capítulo",
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 13,
  //                 color: Colors.white),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 20,
  //           child: Text(
  //             "Verso",
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 13,
  //                 color: Colors.white),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _closeBible() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  Future<dynamic> _bibleData() async {
    final data = await rootBundle.loadString('bible/$version.json');
    final bible = jsonDecode(data);
    return bible;
  }

  void _callBibleSettings() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BibleSettings()));
  }

  Future<void> _getSharedData() async {
    version = await getSharedBibleVersion();
    titleSize = await getSharedBibleTitleFontSize();
    fontSize = await getSharedBibleFontSize();
  }

}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async' show Future ;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:siemb/helpers/book_codes.dart';

import '../display_verses.dart';

class BibleSearchTab extends StatefulWidget {

  final String search;

  const BibleSearchTab( this.search, {super.key,});

  @override
  _BibleSearchTabState createState() => _BibleSearchTabState();
}



class _BibleSearchTabState extends State<BibleSearchTab> {
  late Database db;
  String version = "nvi";


  Future<void> _getDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "nvi.sqlite");

    final exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      // no debug prints

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      final data = await rootBundle.load(join("bible", "nvi.sqlite"));
      final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

    } else {
      // no debug prints
    }
// open the database
    db = await openDatabase(path, readOnly: true);
  }

  Future<List<Map<String, dynamic>>>  _getData (String text) async {
    final res = await db.query(
      "verses",
      where: "text LIKE ?",
        whereArgs: ['%$text%']
    );
    return res.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  void dispose() {
    db.close();

    super.dispose();
  }
  @override
  void initState() {


    _getDB();
    _bibleData();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return searchData( context, widget.search);
  }

  Widget searchData(BuildContext context,
      String search) {
    if (search.isEmpty) {
      return Container(alignment: Alignment.center,
        child: Image.asset("images/search.png", height: 150, width: 150,),);
    } else {
      return createList( context, search);
    }
  }

  Widget createList( BuildContext context,
      String search, ) {
    return FutureBuilder(
      future: _getData(search),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
            future: _bibleData(),
            builder: (BuildContext context, AsyncSnapshot snapshot2) {
              if (snapshot2.hasData) {
                return _createCard(context, snapshot, snapshot2);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }


    Widget _createCard(BuildContext context, AsyncSnapshot snapshot, AsyncSnapshot snapshot2) {

    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: snapshot.data.length,
        itemBuilder: (context, int index) {

          return GestureDetector(
              onTap: () {_displayVerse(context, index, snapshot, snapshot2);},
              child:Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      alignment: Alignment.center,
                      child:
                      Row(
                        children: [
                          // Text('${index + 1}',
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 18,
                          //     color: Colors.black,
                          //   ),
                          // ),
                          Flexible(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${bookCode(snapshot.data[index]['book'])} ${snapshot.data[index]['chapter']}:${snapshot.data[index]['verse']}',
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    snapshot.data[index]['text'].toString().replaceAll('&quot;','"'),
                                    maxLines: 4,
                                    //map1[index],
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),

          );
        }

    );

    }
   _displayVerse(BuildContext context, index, AsyncSnapshot snapshot, AsyncSnapshot snapshot2)  {

    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      final bibleData = (snapshot2.data is List) ? (snapshot2.data as List<dynamic>) : <dynamic>[];
      return DisplayVerses(bibleData,
          snapshot.data[index]['chapter']-1,
          snapshot.data[index]['book'],
          snapshot.data[index]['verse']-1,
          bookCode(snapshot.data[index]['book']));
             }
          )
    );
  }

  Future<dynamic> _bibleData() async {
    final data = await rootBundle.loadString('bible/$version.json');
    final bible = jsonDecode(data);
    return bible;
  }

}

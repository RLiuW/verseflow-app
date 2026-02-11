import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:siemb/helpers/book_codes.dart';
import 'package:siemb/screens/bible/display_verses.dart';

/// SearchDelegate moderno e null-safe para busca na Bíblia
/// Usa a API nativa do Flutter Material Design
class BibleSearchDelegate extends SearchDelegate<String> {
  Database? _db;
  final String _version = "nvi";
  bool _isDbInitialized = false;

  BibleSearchDelegate() : super(
    searchFieldLabel: "Digite a expressão desejada...",
    searchFieldStyle: const TextStyle(fontSize: 16),
    textInputAction: TextInputAction.search,
  );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return _buildEmptyState();
    }
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _buildEmptyState();
    }
    return _buildSearchResults(context);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/search.png",
            height: 150,
            width: 150,
          ),
          const SizedBox(height: 20),
          Text(
            "Digite uma palavra ou expressão para buscar",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeDb(),
      builder: (context, dbSnapshot) {
        if (!dbSnapshot.hasData && !_isDbInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _getData(query),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "Nenhum resultado encontrado",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tente usar outras palavras-chave",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }

            return FutureBuilder<dynamic>(
              future: _bibleData(),
              builder: (context, bibleSnapshot) {
                if (bibleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!bibleSnapshot.hasData) {
                  return const Center(
                    child: Text("Erro ao carregar dados da Bíblia"),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final verse = snapshot.data![index];
                    return _buildVerseCard(
                      context,
                      verse,
                      bibleSnapshot.data!,
                      index,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildVerseCard(
    BuildContext context,
    Map<String, dynamic> verse,
    dynamic bibleData,
    int index,
  ) {
    final bookName = bookCode(verse['book']);
    final chapter = verse['chapter'];
    final verseNum = verse['verse'];
    final text = verse['text'].toString().replaceAll('&quot;', '"');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          '$bookName $chapter:$verseNum',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue[700],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        onTap: () => _displayVerse(
          context,
          verse,
          bibleData,
        ),
      ),
    );
  }

  void _displayVerse(
    BuildContext context,
    Map<String, dynamic> verse,
    dynamic bibleData,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DisplayVerses(
          (bibleData is List) ? List<dynamic>.from(bibleData) : <dynamic>[],
          verse['chapter'] - 1,
          verse['book'],
          verse['verse'] - 1,
          bookCode(verse['book']),
        ),
      ),
    );
  }

  Future<void> _initializeDb() async {
    if (_isDbInitialized && _db != null) {
      return;
    }

    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, "nvi.sqlite");

      final exists = await databaseExists(path);

      if (!exists) {
        await Directory(dirname(path)).create(recursive: true);

        final data = await rootBundle.load(join("bible", "nvi.sqlite"));
        final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        await File(path).writeAsBytes(bytes, flush: true);
      }

      _db = await openDatabase(path, readOnly: true);
      _isDbInitialized = true;
    } catch (e) {
      // no debug prints
      _isDbInitialized = false;
    }
  }

  Future<List<Map<String, dynamic>>> _getData(String text) async {
    if (_db == null || !_isDbInitialized) {
      await _initializeDb();
    }

    if (_db == null) {
      return [];
    }

    try {
      List<Map> res = await _db!.query(
        "verses",
        where: "text LIKE ?",
        whereArgs: ['%$text%'],
        limit: 100, // Limita resultados para melhor performance
      );
      return res.cast<Map<String, dynamic>>();
    } catch (e) {
      // no debug prints
      return [];
    }
  }

  Future<dynamic> _bibleData() async {
    try {
      String data = await rootBundle.loadString('bible/$_version.json');
      return jsonDecode(data);
    } catch (e) {
      // no debug prints
      return null;
    }
  }

  @override
  void dispose() {
    _db?.close();
    super.dispose();
  }
}

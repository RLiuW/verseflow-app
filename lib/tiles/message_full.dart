import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:siemb/helpers/bible_shared_pref.dart';
import 'package:siemb/helpers/book_codes.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/models/user_model.dart';
import 'package:siemb/widgets/glass_card.dart';

class MessageFull extends StatefulWidget {
  final String title;
  final String date;
  final String msg;
  final double titleSize;
  final double fontSize;
  final String docId;

  const MessageFull(
    this.title,
    this.date,
    this.msg,
    this.titleSize,
    this.fontSize,
    this.docId, {
    super.key,
  });

  @override
  _MessageFullState createState() => _MessageFullState();
}

class _MessageFullState extends State<MessageFull> {

  String version = "nvi";
  String message = "";
  int chapIndex = 0;
  int? startVerse;
  int? endVerse;
  int book = 0;
  Database? db;
  int index = 1;
  QuerySnapshot? amens;
  String name = "";

  Future<void> _getDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "$version.sqlite");

    final exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application

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
    }
// open the database
    db = await openDatabase(
      path,
      readOnly: true,
    );
  }

  Future<List<Map<String, dynamic>>> _getData(int book, int chapter) async {
    if (db == null) return <Map<String, dynamic>>[];
    final res = await db!.rawQuery(
        "SELECT text FROM verses WHERE book = $book AND chapter = $chapter");
    return res.cast<Map<String, dynamic>>();
  }

  @override
  void dispose() {
    db?.close();
    super.dispose();
  }

  @override
  void initState() {
    _getSharedData();
    _getQuotedVerses();
    _getDB();




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
    return Scaffold(
        body:
        ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              if (model.isLoading) {
                return const Center(child: CircularProgressIndicator(),);
              }
              return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('mensagens').doc(
                      widget.docId).collection("amen")
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<
                      QuerySnapshot> snapshot3) {
                    amens = snapshot3.data;
                    if (!snapshot3.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),);
                    } else {
                      return FutureBuilder(
                          future: _getQuotedVerses(),
                          builder: (BuildContext context,
                              AsyncSnapshot snapshot) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.surfaceContainerHighest,
                                    Theme.of(context).colorScheme.surface,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width > 600 ? 24 : 12,
                                  8,
                                  MediaQuery.of(context).size.width > 600 ? 24 : 12,
                                  MediaQuery.of(context).padding.bottom + 8,
                                ),
                                child:
                                FutureBuilder(
                                    future: _getData(book, chapIndex),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot2) {
                                      if (snapshot2.data == null) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        return SingleChildScrollView(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context).padding.bottom + 16,
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              Hero(
                                                tag: 'message_${widget.docId}',
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      icon: const Icon(Icons.arrow_back_ios_new_outlined),
                                                    ),
                                                    Expanded(
                                                      child: Material(
                                                        color: Colors.transparent,
                                                        child: Text(
                                                          widget.title,
                                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                message,
                                                textAlign: TextAlign.justify,
                                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                  fontSize: widget.fontSize,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "${l10n.date}: ${widget.date}",
                                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              LayoutBuilder(
                                                builder: (context, constraints) {
                                                  return SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    physics: const BouncingScrollPhysics(),
                                                    child: ConstrainedBox(
                                                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Flexible(
                                                            child: TextButton(
                                                              onPressed: () => _alertDialog(context, snapshot2),
                                                              child: Text(
                                                                l10n.readVerses,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Flexible(
                                                            child: FilledButton.icon(
                                                              onPressed: () async {
                                                                final uid = FirebaseAuth.instance.currentUser?.uid ?? "";
                                                                if (widget.docId.isEmpty) {
                                                                  Fluttertoast.showToast(msg: "Erro: documento inválido.");
                                                                  return;
                                                                }
                                                                if (uid.isEmpty) {
                                                                  Fluttertoast.showToast(msg: "Erro: usuário não identificado. Faça login.");
                                                                  return;
                                                                }
                                                                String name = model.userData["nome"]?.toString().trim() ?? "";
                                                                if (name.isEmpty) {
                                                                  final userDoc = await FirebaseFirestore.instance
                                                                      .collection("usuarios")
                                                                      .doc(uid)
                                                                      .get();
                                                                  name = userDoc.data()?["nome"]?.toString().trim() ?? "";
                                                                }
                                                                if (name.isEmpty) name = "User";

                                                                try {
                                                                  final amenRef = FirebaseFirestore.instance
                                                                      .collection("mensagens")
                                                                      .doc(widget.docId)
                                                                      .collection("amen")
                                                                      .doc(uid);
                                                                  final snapshot2 = await amenRef.get();
                                                                  final amen = {
                                                                    "nome": name,
                                                                    "data": Timestamp.now(),
                                                                    "uid": uid,
                                                                  };
                                                                  if (snapshot2.exists) {
                                                                    await amenRef.delete();
                                                                  } else {
                                                                    await amenRef.set(amen);
                                                                  }
                                                                  if (mounted) setState(() => this.name = name);
                                                                } catch (e) {
                                                                  Fluttertoast.showToast(msg: "Erro ao registrar amém: $e");
                                                                }
                                                              },
                                                              icon: const Icon(Icons.thumb_up_outlined, size: 18),
                                                              label: Text(
                                                                l10n.amen,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                              style: FilledButton.styleFrom(
                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                                shape: const StadiumBorder(),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(height: 10.0),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: snapshot3.data?.docs.length ?? 0,
                                                    itemBuilder: (context, int index) {
                                                      final docs = snapshot3.data?.docs ?? [];
                                                      if (docs.isEmpty) return const SizedBox.shrink();
                                                      final doc = docs[index];
                                                      final docData = doc.data() as Map<String, dynamic>?;
                                                      final nome = docData?["nome"]?.toString().trim() ?? "User";
                                                      final initial = nome.isNotEmpty
                                                          ? nome.substring(0, 1).toUpperCase()
                                                          : "?";
                                                      return GlassCard(
                                                        key: ValueKey(doc.id),
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                        child: Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 16,
                                                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                                              child: Text(
                                                                initial,
                                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 8),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                nome,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                docData?["data"] != null
                                                                    ? DateFormat(DateFormat.YEAR_MONTH_DAY, localeStr).format(
                                                                        (docData!["data"] as Timestamp).toDate().toUtc())
                                                                    : "",
                                                                style: Theme.of(context).textTheme.bodySmall,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 8),
                                                    child: Text(
                                                      "${l10n.total}: ${snapshot3.data?.docs.length ?? 0}",
                                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }),
                              ),
                            );
                          });
                    }
                  }
              );
            }
        )
    );
  }

  Future _getSharedData() async {
    version = await getSharedBibleVersion();
  }

  Future _getQuotedVerses() async {
    message = widget.msg.replaceAll("<v>", "").replaceAll("<vv>", "");
    String msg = widget.msg;
    int start = 0;
    int end = 0;
    int end2 = 0;

    if (msg.contains("<v>") && msg.contains("<vv>")) {
      start = msg.indexOf("<v>") + 3;
      end = msg.indexOf("<vv>");
    }

    String msg2 = msg.length > end && end > start ? msg.substring(start, end) : '';
    if (msg2.contains(":")) {
      end2 = msg2.indexOf(":");
    } else if (msg2.contains(".")) {
      end2 = msg2.indexOf(".");
    }


    int? end3;
    if (msg2.contains("-")) {
      end3 = msg2.indexOf('-');
    }

    if (msg2.isEmpty) return;
    if (end3 == null){
      startVerse = int.tryParse(msg2.substring(end2, msg2.length).replaceAll(RegExp('[^0-9]'), '')) ?? 0;
    } else {
      startVerse = int.tryParse(msg2.substring(end2, end3).replaceAll(RegExp('[^0-9]'), '')) ?? 0;
    }

    if (end3 == null){
      endVerse = null;
    } else {
      endVerse = int.tryParse(msg2.substring(end3, msg2.length).replaceAll(RegExp('[^0-9]'), ''));
    }

    //print("teste endVerse:" + endVerse.toString());
    chapIndex = int.tryParse(msg2.substring(0, end2).replaceAll(RegExp('[^0-9]'), '')) ?? 0;
    //print(chapIndex);
    book = bookName(msg2.substring(0, end2).replaceAll(RegExp(r'[0-9]'), '').trim()) ?? 0;

    // removed debug print
  }

   _alertDialog(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    showDialog(
        context: context,
        builder: (context) => Theme(
              data: theme,
              child: CupertinoAlertDialog(
              title: Center(
                child:  endVerse == null
                    ? Text(
                        "${bookCode(book)}  $chapIndex : $startVerse",
                        style: TextStyle(
                            color: textColor,
                            fontSize: widget.titleSize,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3),
                      )
                    : Text(
                        "${bookCode(book)}  $chapIndex : $startVerse - $endVerse",
                        style: TextStyle(
                            color: textColor,
                            fontSize: widget.titleSize,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3),
                      ),
              ),
              content: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 350,
                  child: ListView.builder(
                    itemCount: endVerse == null ? (startVerse ?? 0) + 1 : (endVerse ?? 0) + 1,
                    itemBuilder: (context, index) {
                      if (startVerse == null || index < (startVerse ?? 0) || snapshot.data == null) {
                        return Container();
                      }
                      final data = snapshot.data as List<dynamic>?;
                      if (data == null || index - 1 < 0 || index - 1 >= data.length) {
                        return Container();
                      }
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data[index - 1].toString().replaceAll('&quot;', '"').replaceAll("text:", "").replaceAll("{", "").replaceAll("}", ""),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: textColor,
                              fontSize: widget.fontSize,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              actions: [
                CupertinoDialogAction(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("Fechar", style: TextStyle(color: textColor)))),
              ],
            )
            ));
  }
}

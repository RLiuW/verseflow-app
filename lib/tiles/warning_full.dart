import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:siemb/helpers/warning_type.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/models/user_model.dart';

class WarningFull extends StatelessWidget {

  String type;
  String date;
  String msg;
  double titleSize;
  double fontSize;
  Map<String, dynamic> amenNumber = {};
  String docId;
  String name = "";
  QuerySnapshot? amens;
  WarningFull(this.type, this.date, this.msg, this.titleSize, this.fontSize, this.docId, {super.key});

  String _dateLocale(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return '${locale.languageCode}_${locale.countryCode ?? (locale.languageCode == 'pt' ? 'BR' : 'US')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeStr = _dateLocale(context);
    return Scaffold(
        body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
      if (model.isLoading) {
        return const Center(child: CircularProgressIndicator(),);
      }
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('avisos').doc(docId).collection("amen")
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<
              QuerySnapshot> snapshot) {
            amens = snapshot.data;
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),);
            } else {
              final scheme = Theme.of(context).colorScheme;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      scheme.surfaceContainerHighest,
                      scheme.surface,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width > 400 ? 16 : 8,
                      8,
                      MediaQuery.of(context).size.width > 400 ? 16 : 8,
                      MediaQuery.of(context).padding.bottom + 16,
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 16,
                      ),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 20.0),
                          Hero(
                            tag: 'warning_$docId',
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: warningType(type),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    type,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: titleSize,
                                      color: scheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: scheme.outlineVariant.withValues(alpha: 0.5),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            child: Text(
                              msg,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: fontSize,
                                color: scheme.onSurface,
                              ),
                            ),
                          ),
                          Text(
                            "${l10n.date}: $date",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: titleSize,
                              color: scheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 15),
                          FilledButton.icon(
                            onPressed: () async {
                              final uid = FirebaseAuth.instance.currentUser?.uid ?? "";
                              if (docId.isEmpty) {
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
                                    .collection("avisos")
                                    .doc(docId)
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
                              } catch (e) {
                                Fluttertoast.showToast(msg: "Erro ao registrar amém: $e");
                              }
                            },
                            icon: const Icon(Icons.thumb_up_outlined, size: 20),
                            label: Text(
                              l10n.amen,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            style: FilledButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width > 400 ? 20 : 12,
                                vertical: 12,
                              ),
                              shape: const StadiumBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 200,
                            child: Column(
                              children: [
                                Flexible(
                                  child: ListView.builder(
                                    itemCount: snapshot.data?.docs.length ?? 0,
                                    itemBuilder: (context, int index) {
                                      final docs = snapshot.data?.docs ?? [];
                                      if (docs.isEmpty) return Container();
                                      final doc = docs[index];
                                      final docData = doc.data() as Map<String, dynamic>?;
                                      final nome = docData?["nome"]?.toString().trim() ?? "User";
                                      return Card(
                                        key: ValueKey(doc.id),
                                        color: scheme.surfaceContainerHighest,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context).size.width > 400 ? 16 : 8,
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  nome,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  docData?["data"] != null
                                                      ? DateFormat(DateFormat.YEAR_MONTH_DAY, localeStr).format(
                                                          (docData!["data"] as Timestamp).toDate().toUtc())
                                                      : "",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  "${l10n.total}: ${snapshot.data?.docs.length ?? 0}",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: scheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }

        );

        }
    )
    );
  }

}

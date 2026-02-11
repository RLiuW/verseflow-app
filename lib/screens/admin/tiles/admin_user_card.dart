import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:siemb/helpers/bible_shared_pref.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/models/user_model.dart';

class AdminUserCard extends StatefulWidget {


  final DocumentSnapshot snapshot;
  const AdminUserCard(this.snapshot, {super.key});

  @override
  _AdminUserCardState createState() => _AdminUserCardState();
}

class _AdminUserCardState extends State<AdminUserCard> {
  String title = '';
  dynamic date;
  String msg = '';
  Map<String, dynamic> userData = {};
  double titleSize = 18;
  double fontSize = 16;
  late FToast fToast;
  final FirebaseFirestore _data = FirebaseFirestore.instance;



  @override
  void initState() {

    _getSharedData();
    fToast = FToast();
    fToast.init(context);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return FutureBuilder(
        future: _getSharedData(),
        builder: (context, snapshot2) {
          return Card(
            color: scheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: Image.asset("images/user_female.png", fit: BoxFit.contain),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Email: ${(widget.snapshot.data() as Map<String, dynamic>?)?["email"]?.toString() ?? ""}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: titleSize,
                                color: scheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${l10n.nameLabel}: ${(widget.snapshot.data() as Map<String, dynamic>?)?["nome"]?.toString() ?? ""}",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: fontSize,
                                color: scheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  OverflowBar(
                    children: [
                      TextButton(
                          onPressed: (){_deleteData();},
                          style: TextButton.styleFrom(
                            foregroundColor: scheme.onSurfaceVariant,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(l10n.deleteUser, style: TextStyle(color: scheme.onSurfaceVariant),),
                              const SizedBox(width: 2,),
                              Icon(Icons.delete, color: scheme.error, size: 20,)
                            ],
                          )
                      ),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       //model.signUp(userData);
                      //       _saveData();},
                      //     child: Row(
                      //       children: <Widget>[
                      //         Text("Salvar cadastro"),
                      //         SizedBox(width: 2,),
                      //         Icon(Icons.save_rounded, color: Colors.white,)
                      //       ],
                      //     ))
                    ],
                  )

                ],
              ),
            ),
          );

        }
    );
  }


  String formatData () {
    final data = (widget.snapshot.data() as Map<String, dynamic>?);
    if (data != null && data['data'] != null) {
      final timestamp = data['data'] as Timestamp?;
      if (timestamp != null) {
        return DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br').format(timestamp.toDate().toUtc());
      }
    }
    return "";
  }


  Future _getSharedData() async {
    //version = await getSharedBibleVersion();
    titleSize =  await getSharedAppTitleFontSize();
    fontSize =  await getSharedAppFontSize();
  }

  void _deleteData() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        final l10nDialog = AppLocalizations.of(dialogContext);
        return CupertinoAlertDialog(
          title: Center(
            child: Text(
              l10nDialog.confirmDelete,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
          content: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Row(
              children: [
                SizedBox(width: 60),
                Icon(Icons.delete_rounded, size: 40),
                SizedBox(width: 20),
                Icon(Icons.person, color: Colors.red, size: 40),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: GestureDetector(
                onTap: () => Navigator.pop(dialogContext),
                child: Text(l10nDialog.cancel),
              ),
            ),
            CupertinoDialogAction(
              child: GestureDetector(
                onTap: () async {
                  final docID = widget.snapshot.id;
                  try {
                    await _data.collection("usuarios").doc(docID).delete();
                    if (!dialogContext.mounted) return;
                    Navigator.of(dialogContext).pop();
                    if (context.mounted) _showToast(l10n.userDeleted);
                  } catch (e) {
                    if (!dialogContext.mounted) return;
                    Navigator.of(dialogContext).pop();
                    if (context.mounted) _showToast(l10n.errorDeleting(e.toString()));
                  }
                },
                child: Text(l10nDialog.yesDelete),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveData() async {


    final data = (widget.snapshot.data() as Map<String, dynamic>?);
    userData = {
      "email" : data?["email"]?.toString() ?? "",
      "nome" : data?["nome"]?.toString() ?? "",
      "senha" : data?["senha"]?.toString() ?? ""
    };

    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        final l10nDialog = AppLocalizations.of(dialogContext);
        return CupertinoAlertDialog(
          title: Center(
            child: Text(
              l10nDialog.confirmCreateUser,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
          content: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Row(
              children: [
                SizedBox(width: 60),
                Icon(Icons.save_rounded, size: 40),
                SizedBox(width: 20),
                Icon(Icons.person, color: Colors.red, size: 40),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: GestureDetector(
                onTap: () => Navigator.pop(dialogContext),
                child: Text(l10nDialog.cancel),
              ),
            ),
            CupertinoDialogAction(
              child: ScopedModelDescendant<UserModel>(
                builder: (context, child, model) {
                  if (model.isLoading) return const Center(child: CircularProgressIndicator());
                  return GestureDetector(
                    onTap: () async {
                      try {
                        await model.signUp(userData);
                        if (!context.mounted) return;
                        _showToast(l10n.registrationAccepted);
                        Navigator.pop(dialogContext);
                      } catch (e) {
                        if (!context.mounted) return;
                        _showToast(l10n.errorAccepting(e.toString()));
                      }
                    },
                    child: Text(l10nDialog.confirm),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  _showToast(String toastText) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, color: Colors.white),
            const SizedBox(width: 12.0),
            Expanded(child: Text(toastText)),
          ],
        ),
        backgroundColor: Colors.greenAccent,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

}

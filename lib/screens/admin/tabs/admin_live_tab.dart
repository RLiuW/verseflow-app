import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siemb/l10n/app_localizations.dart';

class AdminLiveTab extends StatefulWidget {
  const AdminLiveTab({super.key});

  @override
  _AdminLiveTabState createState() => _AdminLiveTabState();
}

class _AdminLiveTabState extends State<AdminLiveTab> {
  TextEditingController liveIDController = TextEditingController();
  final FirebaseFirestore _data = FirebaseFirestore.instance;
  Map<String, dynamic> liveData = {};
  bool livecheck = false;
  final ValueNotifier<bool> _hasErrorNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(color: scheme.background),
        ),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Column(
                  children: [
                    const Expanded(child: SizedBox(height: 2)),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'VerseFlow',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: scheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.administrator,
                            style: theme.textTheme.titleSmall?.copyWith(
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
            SliverFillRemaining(
                child: Column(
                        children: [

                         SizedBox(
                          width: 350,
                          child:
                           RawMaterialButton(
                               fillColor: livecheck ? scheme.surface : scheme.surfaceContainerHighest,
                                      onPressed: _buttonCheck(),
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0)),
                            child: Text(l10n.addLiveId,
                                      style: TextStyle(
                                        color: scheme.primary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),)
                                 ),
                            ),
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 16),
                           child: Row(
                             children: <Widget>[
                               Flexible(
                                 child: Text(
                                   l10n.liveExampleUrl,
                                   style: TextStyle(
                                     color: theme.colorScheme.primary,
                                     fontSize: 15,
                                   ),
                                   overflow: TextOverflow.ellipsis,
                                 ),
                               ),
                               Text(
                                 "nf0kdf2EtGQ",
                                 style: TextStyle(
                                   color: theme.colorScheme.primary,
                                   fontSize: 15,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                             ],
                           ),
                         ),
                        const SizedBox(height: 20,),
                        SizedBox(
                          width: 350,
                          child: Form(
                              child: ValueListenableBuilder(
                                valueListenable: _hasErrorNotifier,
                                builder: (BuildContext context, bool hasError, Widget? child) {
                                  final scheme = Theme.of(context).colorScheme;
                                  return TextFormField(
                                    controller: liveIDController,
                                    onChanged: _updateError,
                                    maxLines: 1,
                                    obscureText: false,
                                    style: TextStyle(color: scheme.onSurface),
                                    decoration: InputDecoration(
                                      errorText: hasError
                                          ? l10n.liveIdMinLength
                                          : null,
                                      hintText: l10n.liveIdHint,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        borderSide: BorderSide(color: scheme.outline),
                                      ),
                                    ),
                                  );
                                }
                              ),
                               ),
                        )
                        ],
                )
            )
          ],
        ),
      ],

    );
  }
  _saveLiveID(){
    liveData = {
      "ID" : liveIDController.text
    };
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Center(
            child:   Text(
              "Salvar esta ID de Live?",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3),
            ),
          ),
          content: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  const SizedBox(width: 60,),
                  const Icon(Icons.add, size: 40,),
                  const SizedBox(width: 20,),
                 Image.asset("images/youtube_icon.png", color: Colors.red, height: 40,)
                ],
              )

          ),
          actions: [

            CupertinoDialogAction(
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancelar"))),
            CupertinoDialogAction(
                child: GestureDetector(
                    onTap: () async {

                      // final snapShot = await _data
                      //     .collection('live')
                      //     .document()
                      //     .get();
                      //
                      // if (snapShot == null || !snapShot.exists) {
                      //   await _data.collection("live").document().setData(liveData);
                      // }else {
                      //   var docID = snapShot.documentID;
                      //   await _data.collection("live").document(docID).updateData(liveData);
                      // }
                      await _data.collection("live").doc("IDLive").set(liveData);
                      _showToast("ID de live adicionada com sucesso!");
                      setState(() {
                        Navigator.pop(context);
                      });

                    },
                    child: const Text("Confirmar"))),
          ],
        ));
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


  void Function()? _buttonCheck() {
    if (livecheck == true) {
      return _saveLiveID;
    } else {
      return null;
    }
  }
  _updateError(String liveID) {
    bool result;
    if (liveID.isNotEmpty && liveID.length == 11) {
      result = false;
      livecheck = true;
      setState(() {

      });
    } else {
      result = true;
      livecheck = false;
      setState(() {

      });
    }
    _hasErrorNotifier.value = result;
  }
}

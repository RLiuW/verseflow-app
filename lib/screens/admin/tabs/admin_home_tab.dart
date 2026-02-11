import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/screens/admin/tiles/admin_message_card.dart';

class AdminHomeTab extends StatefulWidget {
  const AdminHomeTab({super.key});

  @override
  _AdminHomeTabState createState() => _AdminHomeTabState();
}

class _AdminHomeTabState extends State<AdminHomeTab> {
  final FirebaseFirestore _data = FirebaseFirestore.instance;
  TextEditingController textController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  Map<String, dynamic> msgData = {};

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
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width > 400 ? 350 : double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _callAddMessage(context),
                        icon: const Icon(Icons.add_comment_outlined),
                        label: Text(l10n.addMessage),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                  ),
                  // FutureBuilder<QuerySnapshot>(
                  //   future: _data.collection("mensagens").orderBy("data", descending: true).getDocuments(),
                  //   builder: (context,snapshot){
                  //     if(!snapshot.hasData)
                  //       return Center(child: CircularProgressIndicator(),);
                  //     else{
                  //
                  //       return
                          StreamBuilder(
                          stream: _data.collection("mensagens").orderBy("data", descending: true)
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<
                              QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),);
                            }
                            final docs = snapshot.data?.docs ?? [];
                            return Expanded(
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                itemCount: docs.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 16),
                                itemBuilder: (context, index) => AdminMessageCard(docs[index]),
                              ),
                            );
                          }
                        ),
                    //  }
                  //   },
                  // ),
                ],
              )
            )
          ],
        )
      ],
    );
  }

  void _callAddMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            l10n.addMessage,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${l10n.title}: ",
                      style: theme.textTheme.titleSmall?.copyWith(color: scheme.onSurface),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      maxLines: 1,
                      controller: titleController,
                      style: TextStyle(color: scheme.onSurface),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: scheme.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${l10n.messageLabel}: ",
                      style: theme.textTheme.titleSmall?.copyWith(color: scheme.onSurface),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: textController,
                      maxLines: 10,
                      style: TextStyle(color: scheme.onSurface),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: scheme.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _saveData(context);
              },
              child: Text(l10n.save),
            ),
          ],
        ));
  }

  void _saveData(BuildContext context) {
    msgData = {
      "mensagem" : textController.text,
      "título" : titleController.text,
      "data" : Timestamp.now(),
    };

    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            l10n.addThisMessage,
            style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                const SizedBox(width: 60),
                Icon(Icons.add, size: 40, color: scheme.onSurface),
                const SizedBox(width: 20),
                Icon(Icons.warning_amber_outlined, color: scheme.error, size: 40),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                await _data.collection("mensagens").doc().set(msgData);
                _showToast(l10n.messageAddedSuccess);
                if (!context.mounted) return;
                setState(() {});
                Navigator.pop(ctx);
              },
              child: Text(l10n.confirm),
            ),
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
}

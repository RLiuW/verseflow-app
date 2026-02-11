import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/screens/admin/tiles/admin_warning_card.dart';

class AdminWarningTab extends StatefulWidget {
  const AdminWarningTab({super.key});

  @override
  _AdminWarningTabState createState() => _AdminWarningTabState();
}

class _AdminWarningTabState extends State<AdminWarningTab> {
  final FirebaseFirestore _data = FirebaseFirestore.instance;
  TextEditingController textController = TextEditingController();
  Map<String, dynamic> warnData = {};
  String dropdownValue = 'Ensaio';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isWide = MediaQuery.of(context).size.width > 400;
    return Stack(
      children: [
        Positioned.fill(
          child: Container(color: scheme.background),
        ),
        CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
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
                            color: scheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    child: SizedBox(
                      width: isWide ? 350 : double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _callAddWarning(),
                        icon: const Icon(Icons.add_alert_outlined),
                        label: Text(l10n.addWarning),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: _data.collection('avisos').orderBy('data', descending: true).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final docs = snapshot.data?.docs ?? [];
                      return Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          itemCount: docs.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) => AdminWarningCard(docs[index]),
                        ),
                      );
                    },
                  ),
                    //     }
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

  _callAddWarning()  {
    const dropDownItems = ['Ensaio', 'Horário', 'Música', 'Pedido'];
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            l10n.addWarning,
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
                    DropdownButtonFormField<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down_rounded, size: 25),
                      elevation: 2,
                      dropdownColor: scheme.surfaceContainerHigh,
                      style: TextStyle(color: scheme.primary, fontSize: 16),
                      items: dropDownItems.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue == null) return;
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${l10n.messageLabel}:",
                      style: theme.textTheme.titleSmall?.copyWith(color: scheme.onSurface),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: textController,
                      maxLines: 6,
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
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _saveData();
              },
              child: Text(l10n.save),
            ),
          ],
        ));
  }

  _saveData(){



    // no debug prints

      warnData = {
        "mensagem" : textController.text,
        "tipo" : dropdownValue,
        "data" : Timestamp.now(),
      };

    // no debug prints

    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            l10n.addWarning + "?",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                await _data.collection("avisos").doc().set(warnData);
                _showToast("Aviso adicionado com sucesso!");
                if (!context.mounted) return;
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Text(l10n.confirm),
            ),
          ],
        ));
  }

  void _showToast(String toastText) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) => Opacity(opacity: value, child: child),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outlined, color: Theme.of(context).colorScheme.onInverseSurface),
              const SizedBox(width: 12),
              Expanded(child: Text(toastText)),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

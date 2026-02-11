import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/screens/admin/tiles/admin_register_card.dart';

class AdminRegisterTab extends StatefulWidget {
  const AdminRegisterTab({super.key});

  @override
  _AdminRegisterTabState createState() => _AdminRegisterTabState();
}

class _AdminRegisterTabState extends State<AdminRegisterTab> {
  final FirebaseFirestore _data = FirebaseFirestore.instance;
  TextEditingController textController = TextEditingController();
  Map<String, dynamic> contactData = {};
  late FToast fToast;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
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
                    StreamBuilder(
                        stream: _data.collection('cadastros')
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<
                            QuerySnapshot> snapshot) {
                          if ((snapshot.data?.docs.length ?? 0) == 0){
                            return Center(
                              child: Text(l10n.noRegistrationRequests,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),);
                          }
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
                              itemBuilder: (context, index) => AdminRegisterCard(docs[index]),
                            ),
                          );
                        }
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

}

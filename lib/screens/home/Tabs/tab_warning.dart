import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:siemb/tiles/warning_card.dart';


class WarningTab extends StatelessWidget{
  const WarningTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final surfaceContainer = theme.colorScheme.surfaceContainerHighest;

    Widget buildBodyBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [surfaceContainer, surface],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );

    const horizontalPadding = 28.0;
    const verticalSpacing = 16.0;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildBodyBack(),
          Column(
            children: [
              const SizedBox(height: 20),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection("avisos").orderBy("data", descending: true).get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data?.docs ?? [];
                  return Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: verticalSpacing),
                      itemBuilder: (context, index) => WarningCard(docs[index]),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );


  }


}
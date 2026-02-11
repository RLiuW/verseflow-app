import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/models/user_model.dart';
import 'package:siemb/screens/bible/bible_home.dart';
import 'package:siemb/screens/home/Tabs/tab_live.dart';
import 'package:siemb/screens/home/Tabs/tab_main.dart';
import 'package:siemb/screens/home/Tabs/tab_message.dart';
import 'package:siemb/screens/home/Tabs/tab_warning.dart';
import 'package:siemb/screens/home/settings.dart' as AppSettings;

class HomeScreen extends StatefulWidget {
  static const String Bible = "Bíblia";
  static const String Setting = "Configurações";
  static const String SignOut = "Sair";
  static const List<String> choices = <String> [Bible,Setting,SignOut];
  final int moreValue = 0;

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  Future<QuerySnapshot>? _liveQuery;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {
          _liveQuery = FirebaseFirestore.instance.collection('live').get();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if (model.isLoading || !model.isLoggedIn()) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final l10n = AppLocalizations.of(context);
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              leadingWidth: 48,
              leading: const SizedBox(width: 48),
              centerTitle: true,
              title: Text(
                'VerseFlow',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              actions: [
                PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert_outlined),
                  onSelected: (result) async {
                    if (result == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BibleHome(initialPage: 0),
                        ),
                      );
                    } else if (result == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppSettings.Settings(),
                        ),
                      );
                    } else if (result == 2) {
                      model.signOut(context);
                      _showToast(l10n.signOutSuccess);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 0, child: Text(l10n.bible)),
                    PopupMenuItem(value: 1, child: Text(l10n.settingsTitle)),
                    PopupMenuItem(value: 2, child: Text(l10n.signOut)),
                  ],
                ),
              ],
            ),
            body: TabBarView(
              children: [
                const MainTab(),
                const MessageTab(),
                _liveQuery == null
                    ? const Center(child: CircularProgressIndicator())
                    : FutureBuilder<QuerySnapshot>(
                  future: _liveQuery,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            l10n.liveLoadError,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return LiveTab(snapshot);
                  },
                ),
                const WarningTab(),
              ],
            ),
            bottomNavigationBar: TabBar(
              tabs: [
                Tab(icon: const Icon(Icons.home_outlined), text: l10n.home),
                Tab(icon: const Icon(Icons.chat_bubble_outline), text: l10n.message),
                Tab(icon: const Icon(Icons.live_tv_outlined), text: l10n.live),
                Tab(icon: const Icon(Icons.warning_amber_outlined), text: l10n.warnings),
              ],
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
        );
      },
    );
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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
 
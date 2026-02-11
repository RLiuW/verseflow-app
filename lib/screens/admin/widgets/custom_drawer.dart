import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/screens/admin/admin_settings_screen.dart';
import 'package:siemb/screens/admin/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:siemb/models/user_model.dart';
import 'package:siemb/screens/login/login_screen.dart';

class CustomDrawer extends StatefulWidget {
  final PageController pageController;

  const CustomDrawer(this.pageController, {super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget buildDrawerBack() => Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors:[ Color.fromRGBO(0, 153, 153, 0.8),
                Color.fromRGBO(255, 255, 255, 1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
    );
    return Drawer(
      child: Stack(
        children: <Widget>[
          buildDrawerBack(),
          ListView(
            padding: const EdgeInsets.only(top: 20, left: 30),
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8,
                      left: 0,
                      child: Text(
                        l10n.adminModuleTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              DrawerTile(Icons.mail_rounded, l10n.adminMessage, widget.pageController, 0),
              DrawerTile(Icons.warning, l10n.adminWarning, widget.pageController, 1),
              DrawerTile(Icons.live_tv, l10n.adminLive, widget.pageController, 2),
              DrawerTile(Icons.person_add_alt_1, l10n.adminRegisters, widget.pageController, 3),
              DrawerTile(Icons.person, l10n.adminUsers, widget.pageController, 4),
              _SettingsDrawerTile(),
              const Divider(),
              ScopedModelDescendant<UserModel>(
                builder: (context, child, model) {
                  return GestureDetector(
                    onTap: () async {
                      model.signOut(context);
                      _showToast(l10n.signOutSuccess);
                      await Future.delayed(const Duration(seconds: 1));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      l10n.signOut,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  );
                },
              )


            ],
          )
        ],
      ),
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

class _SettingsDrawerTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AdminSettingsScreen()),
          );
        },
        child: SizedBox(
          height: 70,
          child: Row(
            children: [
              const Icon(Icons.settings, size: 30, color: Colors.black),
              const SizedBox(width: 30),
              Text(
                l10n.settingsTitle,
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

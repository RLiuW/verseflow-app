import 'package:flutter/material.dart';
import 'package:siemb/screens/admin/tabs/admin_home_tab.dart';
import 'package:siemb/screens/admin/tabs/admin_live_tab.dart';
import 'package:siemb/screens/admin/tabs/admin_register_tab.dart';
import 'package:siemb/screens/admin/tabs/admin_user_tab.dart';
import 'package:siemb/screens/admin/tabs/admin_warning_tab.dart';
import 'package:siemb/screens/admin/widgets/custom_drawer.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});


  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final _pageController = PageController();
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.background;
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          backgroundColor: backgroundColor,
          body: AdminHomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          backgroundColor: backgroundColor,
          body: AdminWarningTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          backgroundColor: backgroundColor,
          body: AdminLiveTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          backgroundColor: backgroundColor,
          body: AdminRegisterTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          backgroundColor: backgroundColor,
          body: AdminUserTab(),
          drawer: CustomDrawer(_pageController),
        ),
      ],
    );
  }
}

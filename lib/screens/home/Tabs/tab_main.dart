import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MainTab extends StatefulWidget {
  const MainTab({super.key});



  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> with TickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> scaleAnimation;
  String warning = "";
  String message = "";
  int messagenumber = 0;
  int warningnumber = 0;
  DateTime now = DateTime.now();
  bool _userDataLoadRequested = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {
        if (_animationController.status == AnimationStatus.completed) {

          _animationController.stop();
        }
      });
    });


    scaleAnimation = Tween(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceOut
    ));
    initializeDateFormatting();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_userDataLoadRequested && mounted) {
      _userDataLoadRequested = true;
      ScopedModel.of<UserModel>(context).loadCurrentUser();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
            children: [
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection("mensagens").orderBy("data", descending: true).get(),
                builder: (context, snapshot){
                  messagenumber = snapshot.data?.docs.length ?? 0;
                  if(!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection("avisos").orderBy("data", descending: true).get(),
                  builder: (context, snapshot) {
                    warningnumber = snapshot.data?.docs.length ?? 0;
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Column(
                          children: <Widget>[
                            const SizedBox(height: 20,),
                            ScopedModelDescendant<UserModel>(
                              builder: (context, child, model) {
                                if (model.isLoading) {
                                  return const Center(child: CircularProgressIndicator(),);
                                }
                                final theme = Theme.of(context);
                                final onSurface = theme.colorScheme.onSurface;
                                final nome = model.userData["nome"]?.toString().trim();
                                final nomeWidget = (nome == null || nome.isEmpty)
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : Text(
                                        nome,
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: onSurface,
                                        ),
                                      );
                                return Container(
                                  alignment: Alignment.topLeft,
                                  child: AnimatedBuilder(
                                    animation: _animationController,
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Text(l10n.hello, style: theme.textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: onSurface,
                                          ),),
                                          nomeWidget,
                                        ],
                                      ),
                                    ),
                                    builder: (BuildContext context, Widget? child) {
                                      return Opacity(
                                        opacity: _animationController.value,
                                        child: Transform.scale(
                                          scale: _animationController.value,
                                          child: child!
                                        )
                                      );
                                    }
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 40,),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('mensagens')
                                    .orderBy('data', descending: true)
                                    .snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<
                                    QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),);
                                  } else {
                                    return _testMessage(context, l10n, snapshot.data?.docs.length ?? 0);
                                  }
                                }
                            ),
                            const SizedBox(height: 60,),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('avisos')
                                    .orderBy('data', descending: true)
                                    .snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<
                                    QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),);
                                  } else {
                                    return _testWarn(context, l10n, snapshot.data?.docs.length ?? 0);
                                  }
                                }
                            ),
                            const SizedBox(height: 200,),
                            _showDate(context, l10n),
                          ]
                      );
                    }
                  }
                  );
                  }
                }
              ),
            ],
          ),
      );
  }


  Widget _testMessage(BuildContext context, AppLocalizations l10n, int msgnumber) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
    if (msgnumber > messagenumber) {
      messagenumber = msgnumber;
      message = l10n.youHaveNewMessages;
      return AnimatedBuilder(
        animation: scaleAnimation,
        child: Container(
          child: Card(
            child: Row(
              children: [
                Image.asset("images/new_message.png", height: 60, width: 60, alignment: Alignment.centerLeft,),
                const SizedBox(width: 2,),
                Flexible(
                  child: Text(message, style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),),
                ),
              ],
            ),
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return Opacity(
            opacity: scaleAnimation.value,
            child: Transform.scale(
              scale: scaleAnimation.value,
              child: child!
            )
          );
        }
      );
    } else {
      message = l10n.noNewMessages;
      return AnimatedBuilder(
        animation: scaleAnimation,
        child: Container(
          child: Card(
            child: Row(
              children: [
                Image.asset("images/no_message.png", height: 60, width: 60, alignment: Alignment.centerLeft,),
                const SizedBox(width: 2,),
                Flexible(
                  child: Text(message, style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: onSurfaceVariant,
                  ),),
                ),
              ],
            ),
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return Opacity(
            opacity: scaleAnimation.value,
            child: Transform.scale(
              scale: scaleAnimation.value,
              child: child!
            )
          );
        }
      );
    }
  }

  Widget _testWarn(BuildContext context, AppLocalizations l10n, int warnnumber) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
    if (warnnumber > warningnumber) {
      warningnumber = warnnumber;
      warning = l10n.youHaveNewWarnings;
      return AnimatedBuilder(
        animation: scaleAnimation,
        child: Container(
          child: Card(
            child: Row(
              children: [
                Image.asset("images/warning_home_on.png", height: 60, width: 60, alignment: Alignment.centerLeft),
                const SizedBox(width: 2,),
                Flexible(
                  child: Text(warning, style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),),
                ),
              ],
            ),
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return Opacity(
            opacity: scaleAnimation.value,
            child: Transform.scale(
              scale: scaleAnimation.value,
              child: child!
            )
          );
        }
      );
    } else {
      warning = l10n.noNewWarnings;
      return AnimatedBuilder(
        animation: scaleAnimation,
        child: Container(
          child: Card(
            child: Row(
              children: [
                Image.asset("images/warning_home_off.png", height: 60, width: 60, alignment: Alignment.centerLeft),
                const SizedBox(width: 2,),
                Flexible(
                  child: Text(warning, style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: onSurfaceVariant,
                  ),),
                ),
              ],
            ),
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return Opacity(
            opacity: scaleAnimation.value,
            child: Transform.scale(
              scale: scaleAnimation.value,
              child: child!
            )
          );
        }
      );
    }
  }

  Widget _showDate(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final locale = Localizations.localeOf(context);
    final localeStr = '${locale.languageCode}_${locale.countryCode ?? (locale.languageCode == 'pt' ? 'BR' : 'US')}';
    final dateStr = DateFormat(DateFormat.YEAR_MONTH_DAY, localeStr).format(now);
    final timeStr = DateFormat(DateFormat.HOUR24_MINUTE, localeStr).format(now);
    return AnimatedBuilder(
      animation: _animationController,
      child: Container(
        alignment: Alignment.bottomRight,
        child: Column(
          children: [
            Text(
              '${l10n.date}: $dateStr',
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18, color: onSurface),
            ),
            const SizedBox(height: 5,),
            Text(
              '${l10n.time}: $timeStr',
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18, color: onSurface),
            ),
          ],
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _animationController.value,
          child: Transform.scale(
            scale: _animationController.value,
            child: child!
          )
        );
      }
    );
  }


  }




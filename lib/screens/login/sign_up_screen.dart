import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/screens/login/login_screen.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, this.initialLocale});

  final Locale? initialLocale;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseFirestore _data = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> _emailHasErrorNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _passwordHasErrorNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _nameHasErrorNotifier = ValueNotifier(false);

  bool emailcheck = false;
  bool passwordcheck = false;
  bool namecheck = false;

  void _updateErrorEmail(String email) {
    bool result;
    if (email.contains("@") && email.contains(".com") && email.isNotEmpty) {
      result = false;
      emailcheck = true;
      setState(() {

      });
    } else {
      result = true;
      emailcheck = false;
      setState(() {

      });
    }
    _emailHasErrorNotifier.value = result;
  }


  void _updateErrorPass(String password) {
    bool result;
    if (password.length > 5 && password.isNotEmpty) {
      result = false;
      passwordcheck = true;
      setState(() {

      });
    } else {
      result = true;
      passwordcheck = false;
      setState(() {

      });
    }
    _passwordHasErrorNotifier.value = result;
  }

  void _updateErrorName(String name) {
    bool result;
    if (name.length > 10 && name.isNotEmpty) {
      result = false;
      namecheck = true;
      setState(() {

      });
    } else {
      result = true;
      namecheck = false;
      setState(() {

      });
    }
    _nameHasErrorNotifier.value = result;
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.initialLocale ?? Localizations.localeOf(context);
    return Localizations(
      locale: locale,
      delegates: AppLocalizations.localizationsDelegates,
      child: Builder(
        builder: (ctx) {
          final l10n = AppLocalizations.of(ctx);
          return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background_degrade.png"),
                fit: BoxFit.fill
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 70, bottom: 32,),
                    child: Row(
                      children: [
                        const SizedBox(width: 75,),
                        Image.asset("images/add_female.png",
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 5,),
                        Image.asset("images/add_male.png",
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  Form(
                    child: Column(
                      children: <Widget>[
                        ValueListenableBuilder(
                            valueListenable: _nameHasErrorNotifier,
                            builder: (BuildContext context, bool hasError, Widget? child) {
                              return
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.white24,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: nameController,
                                    onChanged: _updateErrorName,
                                    obscureText: false,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      icon: const Icon(
                                        Icons.person_add_alt_1_outlined,
                                        color: Colors.white,
                                      ),
                                      border: InputBorder.none,
                                      hintText: l10n.signUpNameHint,
                                      hintStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 30,
                                          right: 30,
                                          bottom: 30,
                                          left: 5
                                      ),
                                      errorText: hasError
                                          ? l10n.signUpNameError
                                          : null,
                                    ),
                                  ),
                                );
                            }
                        ),

                        ValueListenableBuilder(
                            valueListenable: _emailHasErrorNotifier,
                            builder: (BuildContext context, bool hasError, Widget? child) {
                              return
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.white24,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: emailController,
                                    onChanged: _updateErrorEmail,
                                    obscureText: false,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      icon: const Icon(
                                        Icons.email_outlined,
                                        color: Colors.white,
                                      ),
                                      border: InputBorder.none,
                                      hintText: l10n.loginEmail,
                                      hintStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 30,
                                          right: 30,
                                          bottom: 30,
                                          left: 5
                                      ),
                                      errorText: hasError
                                          ? l10n.loginEmailInvalid
                                          : null,
                                    ),
                                  ),
                                );
                            }
                        ),
                        ValueListenableBuilder(
                            valueListenable: _passwordHasErrorNotifier,
                            builder: (BuildContext context, bool hasError, Widget? child) {
                              return
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.white24,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: passwordController,
                                    onChanged: _updateErrorPass,
                                    obscureText: true,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      icon: const Icon(
                                        Icons.lock_outline,
                                        color: Colors.white,
                                      ),
                                      border: InputBorder.none,
                                      hintText: l10n.loginPassword,
                                      hintStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 30,
                                          right: 30,
                                          bottom: 30,
                                          left: 5
                                      ),
                                      errorText: hasError
                                          ? l10n.loginPasswordMinLength
                                          : null,
                                    ),
                                  ),
                                );
                            }
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              //StaggerAnimation(
              // controller: _animationController.view
              const SizedBox(
                height: 25,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 153, 153, 1.0),
                          disabledBackgroundColor: const Color.fromRGBO(0, 153, 153, 0.2),
                        ),
                        onPressed: _buttonCheck(l10n),
                        child: Text(
                            l10n.signUpButton,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.3
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {_callSignUp();},
                child: Text(
                  l10n.signUpLoginPrompt,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontSize: 15,
                      letterSpacing: 0.5
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
          );
        },
      ),
    );
  }

  void Function()? _buttonCheck(AppLocalizations l10n) {
    if (emailcheck && passwordcheck && namecheck) {
      return () => _signIn(l10n);
    }
    return null;
  }

  Future<void> _signIn(AppLocalizations l10n) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final uid = userCredential.user!.uid;
      await _data.collection('cadastros').doc(uid).set({
        "nome": nameController.text.trim(),
        "email": emailController.text.trim(),
        "data": Timestamp.now(),
        "status": "pendente",
      });
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _alertDialogSuccess(context, l10n.cadastroEnviado, l10n.closeButton);
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final title = l10n.signUpTitle;
      final closeLabel = l10n.signUpClose;
      final message = e.code == 'email-already-in-use'
          ? l10n.signUpDuplicateEmailMessage
          : "Erro: ${e.message}";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _alertDialog(context, title, message, closeLabel);
      });
    } catch (e) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _alertDialog(context, l10n.signUpTitle, "Erro inesperado: $e", l10n.signUpClose);
      });
    }
  }

  void _alertDialogSuccess(BuildContext context, String message, String closeLabel) {
    showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            message,
            style: const TextStyle(color: Colors.black, fontSize: 18, letterSpacing: 0.3),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: GestureDetector(
              onTap: () {
                emailController.clear();
                nameController.clear();
                passwordController.clear();
                setState(() {});
                Navigator.pop(ctx);
                Navigator.of(context).pop();
              },
              child: Text(closeLabel),
            ),
          ),
        ],
      ),
    );
  }


  _callSignUp(){
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return const LoginScreen();}));
  }

  void _alertDialog(BuildContext context, String title, String message, String closeLabel) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              letterSpacing: 0.3,
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: GestureDetector(
              onTap: () {
                emailController.clear();
                nameController.clear();
                passwordController.clear();
                setState(() {});
                Navigator.pop(context);
              },
              child: Text(closeLabel),
            ),
          ),
        ],
      ),
    );
  }
}

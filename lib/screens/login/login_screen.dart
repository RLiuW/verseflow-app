// Firestore security rules (suggested):
// match /cadastros/{userId} {
//   allow read: if isAdmin();
//   allow create: if request.auth != null;  // user created in Auth during sign-up
//   allow update, delete: if isAdmin();
// }
// match /usuarios/{userId} {
//   allow read, write: if request.auth.uid == userId || isAdmin();
// }

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:siemb/helpers/app_constants.dart';
import 'package:siemb/helpers/bible_shared_pref.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:siemb/models/user_model.dart';
import 'package:siemb/screens/admin/admin_home_screen.dart';
import 'package:siemb/screens/home/home_screen.dart';
import 'package:siemb/screens/login/sign_up_screen.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static bool _pendingApprovalHandled = false;

  final ValueNotifier<bool> _emailHasErrorNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _passwordHasErrorNotifier = ValueNotifier(false);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool emailcheck = false;
  bool passwordcheck = false;
  Locale _loginLocale = const Locale('pt', 'BR');

  @override
  void initState() {
    super.initState();
    emailcheck = false;
    passwordcheck = false;
    getAppLocaleAsync().then((locale) {
      if (mounted) setState(() => _loginLocale = locale);
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("images/background_degrade.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 600 ? 48 : 16,
                  vertical: 16,
                ),
                child: ScopedModelDescendant<UserModel>(
                  builder: (context, child, model) {
                    if (model.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final isAdmin = model.userData["email"] == AppConstants.adminEmail ||
                        model.firebaseUser?.email == AppConstants.adminEmail;
                    if (model.isLoggedIn() && isAdmin) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
                        );
                      });
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (model.isLoggedIn() && !isAdmin) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      });
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Center(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Localizations(
                            locale: _loginLocale,
                            delegates: AppLocalizations.localizationsDelegates,
                            child: Builder(
                              builder: (ctx) {
                                final l10n = AppLocalizations.of(ctx);
                                final iconColor = colorScheme.primary;
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                    child: Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: (isDark ? colorScheme.surface : Colors.white)
                                            .withValues(alpha: 0.85),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: colorScheme.outline.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Form(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              "images/biblia.jpg",
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.contain,
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              l10n.loginLanguageLabel,
                                              style: theme.textTheme.titleSmall?.copyWith(
                                                color: isDark ? colorScheme.onSurface : null,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            SegmentedButton<Locale>(
                                              segments: const [
                                                ButtonSegment<Locale>(
                                                  value: Locale('pt', 'BR'),
                                                  label: Text('Português'),
                                                ),
                                                ButtonSegment<Locale>(
                                                  value: Locale('en', 'US'),
                                                  label: Text('English'),
                                                ),
                                              ],
                                              selected: {_loginLocale},
                                              onSelectionChanged: (Set<Locale> selected) {
                                                setState(() => _loginLocale = selected.first);
                                              },
                                            ),
                                            const SizedBox(height: 24),
                                            ValueListenableBuilder<bool>(
                                              valueListenable: _emailHasErrorNotifier,
                                              builder: (context, hasError, _) {
                                                return TextFormField(
                                                  controller: emailController,
                                                  onChanged: _updateErrorEmail,
                                                  keyboardType: TextInputType.emailAddress,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: colorScheme.surfaceContainerHighest
                                                        .withValues(alpha: 0.8),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    prefixIcon: Icon(Icons.email_outlined, color: iconColor),
                                                    hintText: l10n.loginEmail,
                                                    errorText: hasError ? l10n.loginEmailInvalid : null,
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            ValueListenableBuilder<bool>(
                                              valueListenable: _passwordHasErrorNotifier,
                                              builder: (context, hasError, _) {
                                                return TextFormField(
                                                  controller: passwordController,
                                                  onChanged: _updateErrorPass,
                                                  obscureText: true,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: colorScheme.surfaceContainerHighest
                                                        .withValues(alpha: 0.8),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    prefixIcon: Icon(Icons.lock_outlined, color: iconColor),
                                                    hintText: l10n.loginPassword,
                                                    errorText: hasError ? l10n.loginPasswordMinLength : null,
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 12),
                                            TextButton(
                                              onPressed: () async {
                                                if (emailController.text.isEmpty) {
                                                  _showToast(l10n.enterEmailForRecovery, Colors.redAccent);
                                                }
                                                model.recoverPass(emailController.text);
                                                await Future.delayed(const Duration(seconds: 1));
                                                _showToast(l10n.recoverySentMessage, Colors.greenAccent);
                                              },
                                              child: Text(l10n.forgotPassword),
                                            ),
                                            const SizedBox(height: 16),
                                            SizedBox(
                                              width: double.infinity,
                                              child: FilledButton(
                                                onPressed: _buttonCheck(),
                                                child: Text(l10n.loginButton),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            TextButton(
                                              onPressed: _callSignUp,
                                              child: Text(l10n.signUpPrompt),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void Function()? _buttonCheck() {
    if (emailcheck && passwordcheck) {
      debugPrint("$emailcheck");
      debugPrint("$passwordcheck");
      return () {_signIn();};
    } else {
      return () {};
    }



}
  Future<bool> searchUser(String email) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('company')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    final List<QueryDocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Future<void> _signIn() async {
    final UserModel model = ScopedModel.of<UserModel>(context);
    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      await model.signIn(email, password, context, navigate: false);
      if (!mounted) return;

      final err = model.signInError;
      if (err != null && err.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showToast(_formatAuthError(err), Colors.redAccent);
        });
        return;
      }

      final uid = model.firebaseUser?.uid;
      if (uid == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showToast("Falha ao obter usuário após login.", Colors.redAccent);
        });
        return;
      }

      // Bloquear se usuário está pendente em cadastros e ainda não aprovado em usuarios (flag evita loop)
      if (_pendingApprovalHandled) return;
      final pendenteDoc = await FirebaseFirestore.instance
          .collection("cadastros")
          .doc(uid)
          .get();
      final aprovadoDoc = await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(uid)
          .get();
      if (pendenteDoc.exists &&
          pendenteDoc.data()?["status"] == "pendente" &&
          !aprovadoDoc.exists) {
        _pendingApprovalHandled = true;
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showPendingApprovalDialog(() {
            _pendingApprovalHandled = false;
          });
        });
        return;
      }

      bool isAdmin = email == AppConstants.adminEmail;
      final docCad = await FirebaseFirestore.instance.collection("cadastros").doc(uid).get();
      if (!isAdmin && docCad.exists) {
        final d = docCad.data();
        isAdmin = (d?["isAdmin"] == true) || (d?["email"] == AppConstants.adminEmail);
      } else if (!isAdmin) {
        final docUser = await FirebaseFirestore.instance.collection("usuarios").doc(uid).get();
        if (docUser.exists) {
          final d = docUser.data();
          isAdmin = (d?["isAdmin"] == true) || (d?["email"] == AppConstants.adminEmail);
        }
      }

      // Só permite home para não-admin se tiver doc em usuarios (aprovado)
      if (!isAdmin && !aprovadoDoc.exists) {
        if (_pendingApprovalHandled) return;
        _pendingApprovalHandled = true;
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showPendingApprovalDialog(() {
            _pendingApprovalHandled = false;
          });
        });
        return;
      }

      if (!mounted) return;
      await setSharedAppLanguage(
        _loginLocale.languageCode == 'en' ? 'en-US' : 'pt-BR',
      );
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (isAdmin) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminHomeScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      });
    } catch (e, _) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showToast(e.toString().replaceFirst("Exception: ", ""), Colors.redAccent);
      });
    }
  }

  static String _formatAuthError(String raw) {
    if (raw.contains("user-not-found") || raw.contains("USER_NOT_FOUND")) return "Não existe usuário registrado com este email!";
    if (raw.contains("wrong-password") || raw.contains("WRONG_PASSWORD")) return "Senha incorreta.";
    if (raw.contains("invalid-email") || raw.contains("INVALID_EMAIL")) return "Email inválido.";
    if (raw.contains("too-many-requests")) return "Muitas tentativas. Tente mais tarde.";
    if (raw.contains("network-request-failed")) return "Sem conexão. Verifique a internet.";
    return raw.length > 80 ? "${raw.substring(0, 80)}..." : raw;
  }



  void _callSignUp() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SignUpScreen(initialLocale: _loginLocale),
    ));
  }

  void _showPendingApprovalDialog([void Function()? onClose]) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx).pendenteTitle),
        content: Text(AppLocalizations.of(ctx).pendenteMessage),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(ctx);
              onClose?.call();
            },
            child: Text(AppLocalizations.of(ctx).okButton),
          ),
        ],
      ),
    );
  }

  void _showToast(String toastText, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: child,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outlined, color: Theme.of(context).colorScheme.onInverseSurface),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  toastText,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

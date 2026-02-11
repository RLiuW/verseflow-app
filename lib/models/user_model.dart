import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:siemb/screens/admin/admin_home_screen.dart';
import 'package:siemb/screens/home/home_screen.dart';
import 'package:siemb/helpers/app_constants.dart';
import 'package:siemb/screens/login/login_screen.dart';

class UserModel extends Model{
   final FirebaseAuth _auth = FirebaseAuth.instance;
   final FirebaseFirestore _data = FirebaseFirestore.instance;
   User? firebaseUser;
   Map<String, dynamic> userData = {};
   bool isLoading = false;
   String? signInError;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    loadCurrentUser();
  }

Future<void> signUp(Map<String, dynamic> userData) async {
  isLoading = true;
  notifyListeners();
  firebaseUser = (await _auth.createUserWithEmailAndPassword(email: userData["email"].toString(), password: userData["senha"].toString())).user;
  await _saveUserData(userData);
  isLoading = false;
  notifyListeners();

}
void signOut(BuildContext context) async {
  await _auth.signOut();
  userData = {};
  firebaseUser = null;
  notifyListeners();
  //Future.delayed(Duration(seconds: 2));
  if (context.mounted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
  //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {return HomeScreen();}));

}
// Ajuste no Sign-In para evitar navegação antes de carregar dados
Future<void> signIn(String email, String password, BuildContext context, {bool navigate = true}) async {
  signInError = null;
  isLoading = true;
  notifyListeners();

  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    firebaseUser = result.user;
    await firebaseUser?.getIdToken(true);

    await loadCurrentUser();

    if (navigate && context.mounted) {
      if (email == AppConstants.adminEmail) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminHomeScreen()));
      } else {
        // Se os dados foram carregados, vai para Home
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }
  } catch (e) {
    signInError = "Erro ao entrar. Verifique suas credenciais.";
    // ... tratamento de erro
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

void recoverPass(String email){
  _auth.sendPasswordResetEmail(email: email);

}

bool isLoggedIn(){
return firebaseUser != null;
}

Future<void> _saveUserData(Map<String, dynamic> userData) async {
  this.userData = userData;
  if (firebaseUser != null) {
    // Primeiro grava o perfil definitivo; só depois tenta remover pendências.
    await _data.collection("usuarios").doc(firebaseUser!.uid).set(userData);

    // Proteção: dependendo do fluxo antigo/novo, o cadastro pendente pode estar com ID = uid ou email.
    final email = userData["email"]?.toString();
    try {
      await _data.collection("cadastros").doc(firebaseUser!.uid).delete();
    } catch (_) {}
    if (email != null && email.isNotEmpty) {
      try {
        await _data.collection("cadastros").doc(email).delete();
      } catch (_) {}
    }
  }
}

Future<void> loadCurrentUser() async {
  if (firebaseUser == null) firebaseUser = _auth.currentUser;
  if (firebaseUser == null) return;

  final uid = firebaseUser!.uid;
  final email = firebaseUser!.email;

  Map<String, dynamic>? loaded;

  // 1) Preferir sempre a coleção definitiva "usuarios" (usuário aprovado).
  try {
    final docUser = await _data.collection("usuarios").doc(uid).get();
    if (docUser.exists) {
      loaded = (docUser.data() ?? {});
    }
  } on FirebaseException catch (_) {
    // Evita crash em caso de permission-denied; a UI pode seguir com fallback.
  }

  // 2) Se não existir em "usuarios", tenta buscar em "cadastros".
  // Observação: em muitas regras, cadastros é admin-only; trate permission-denied com fallback.
  if (loaded == null || loaded.isEmpty) {
    try {
      final docPendingByUid = await _data.collection("cadastros").doc(uid).get();
      if (docPendingByUid.exists) {
        loaded = (docPendingByUid.data() ?? {});
      }
    } on FirebaseException catch (_) {}
  }

  if (loaded == null || loaded.isEmpty) {
    final emailId = email?.trim();
    if (emailId != null && emailId.isNotEmpty) {
      try {
        final docPendingByEmail = await _data.collection("cadastros").doc(emailId).get();
        if (docPendingByEmail.exists) {
          loaded = (docPendingByEmail.data() ?? {});
        }
      } on FirebaseException catch (_) {}
    }
  }

  if (loaded != null) {
    userData = loaded;
  }

  notifyListeners();
}   
} 
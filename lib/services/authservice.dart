import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internapp/screens/login.dart';
import 'package:internapp/screens/signup.dart';
import 'package:internapp/services/user.dart';
import 'package:provider/provider.dart';

class AuthService extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Signup();
          } else {
            return LoginPage();
          }
        });
  }

  signOut() async {
    await _auth.signOut();
  }

  signIn(AuthCredential authCreds) async {
    try {
      AuthResult result = await _auth.signInWithCredential(authCreds);

      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);
    print(currentUser.uid);

    return handleAuth();
  }
}

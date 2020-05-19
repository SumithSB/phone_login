import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:internapp/services/authservice.dart';
import 'package:internapp/services/user.dart';
import 'package:provider/provider.dart';

void main() => (runApp(
      Phoenix(
        child: MyApp(),
      ),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
            accentColor: Colors.redAccent, primaryColor: Colors.redAccent),
        debugShowCheckedModeBanner: false,
        home: AuthService().handleAuth(),
      ),
    );
  }
}

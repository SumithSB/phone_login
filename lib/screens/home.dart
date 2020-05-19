import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internapp/services/authservice.dart';
import 'package:internapp/services/database_service.dart';
import 'package:internapp/services/loading.dart';
import 'package:internapp/services/user.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserData userData;
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: currentUser?.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                title: Text('Home'),
                centerTitle: true,
                backgroundColor: Colors.redAccent,
                actions: <Widget>[
                  FlatButton.icon(
                      onPressed: () {
                        AuthService().signOut();
                        Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    AuthService().handleAuth()));
                      },
                      icon: Icon(Icons.exit_to_app),
                      label: Text('Logout'))
                ],
              ),
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 100.0,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('images/profile.png'),
                    ),
                    Text(
                      "Hello ${userData?.name}",
                      style: TextStyle(fontSize: 25.0),
                    ),
                    Text(
                      "Phone number:${userData?.phoneNo}",
                      style: TextStyle(fontSize: 25.0),
                    ),
                    Text(
                      "Email:${userData?.email}",
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ],
                ),
              ));
        } else {
          return Loading();
        }
      },
    );
  }
}

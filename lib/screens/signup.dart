import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internapp/screens/home.dart';
import 'package:internapp/services/database_service.dart';
import 'package:internapp/services/loading.dart';
import 'package:internapp/services/textDecoration.dart';
import 'package:internapp/services/user.dart';
import 'package:provider/provider.dart';

final usersCollection = Firestore.instance.collection('users');

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _key = GlobalKey<FormState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();

  FirebaseUser user;
  bool isLoading = true;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    FirebaseUser fuser = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = fuser;
    });
    String uid = user.uid;
    _checkUserExists(uid);
  }

  _checkUserExists(String uid) async {
    DocumentSnapshot docref =
        await Firestore.instance.collection('users').document(uid).get();
    if (docref.exists && docref != null) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);
    if (isLoading) {
      return Loading();
    } else
      return Scaffold(
        appBar: AppBar(
            title: Text('Sign-up!'),
            centerTitle: true,
            backgroundColor: Colors.redAccent),
        body: Form(
          key: _key,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          validator: (val) =>
                          val.isEmpty ? "Please enter name" : null,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Enter your name'),
                          controller: _name,
                        )),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          validator: (val) =>
                          val.isEmpty ? "Please enter email" : null,
                          keyboardType: TextInputType.emailAddress,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Enter your email'),
                          controller: _email,
                        )),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          validator: (val) =>
                              val.isEmpty ? "Please enter phone number" : null,
                          keyboardType: TextInputType.phone,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Enter your phone number'),
                          controller: _phone,
                        )),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 100,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Raleway',
                                fontSize: 18.0),
                          ),
                          color: Colors.redAccent,
                          onPressed: () async {
                            if (_key.currentState.validate()) {
                              await DatabaseService(uid: currentUser.uid)
                                  .updateUserData(
                                      _name.text, _email.text, _phone.text);
                              _name.clear();
                              _phone.clear();
                              _email.clear();
                              Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                           }
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}

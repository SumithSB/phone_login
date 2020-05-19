import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internapp/services/authservice.dart';
import 'package:internapp/services/textDecoration.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String phoneNo, verificationId, smsCode;

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Login!'),
          centerTitle: true,
          backgroundColor: Colors.redAccent),
      body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    //controller: _phone,
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Enter Phone Number', prefixText: '+91'),
                    onChanged: (val) {
                      setState(() {
                        this.phoneNo = '+91' + val;
                      });
                    },
                  )),
              SizedBox(
                height: 10,
              ),
              codeSent
                  ? Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Enter OTP'),
                        onChanged: (val) {
                          setState(() {
                            this.smsCode = val;
                          });
                        },
                      ))
                  : Container(),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 100,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: Colors.redAccent,
                      child: Center(
                          child: codeSent
                              ? Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text('Verify',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                      onPressed: () {
                        if (codeSent) {
                          AuthService().signInWithOTP(smsCode, verificationId);
                        } else {
                          verifyPhone(phoneNo);
                        }
                      }))
            ],
          )),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}

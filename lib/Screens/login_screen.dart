import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/Screens/home_screen.dart';

enum MobileVerification {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerification currentState = MobileVerification.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  String verficationId;
  bool showLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();

  void singInWithPhoneAuthCredential(phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });
      if (authCredential?.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      _scaffoldkey.currentState.showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
  }

  getMobileFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(hintText: "Phone Number"),
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          // controller: phoneController,
          decoration: InputDecoration(hintText: "Phone Number"),
        ),
        SizedBox(
          height: 20,
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              showLoading = true;
            });

            _auth.verifyPhoneNumber(
              phoneNumber: phoneController.text,
              verificationCompleted: (phoneAuthCredential) async {
                setState(() {
                  showLoading = false;
                });
              },
              verificationFailed: (verificationFailed) async {
                setState(() {
                  showLoading = false;
                });
                _scaffoldkey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(verificationFailed.message),
                  ),
                );
              },
              codeSent: (verficationId, resendingToken) async {
                setState(() {
                  showLoading = false;
                  currentState = MobileVerification.SHOW_OTP_FORM_STATE;
                  this.verficationId = verficationId;
                });
              },
              codeAutoRetrievalTimeout: (verificationId) async {
                return Duration(
                  seconds: 10,
                );
              },
            );
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Text("SEND"),
        ),
        Spacer(),
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: otpController,
          decoration: InputDecoration(hintText: "Enter OTP"),
        ),
        SizedBox(
          height: 20,
        ),
        FlatButton(
          onPressed: () {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verficationId, smsCode: otpController.text);
            singInWithPhoneAuthCredential(phoneAuthCredential);
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Text("VERIFY"),
        ),
        Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        body: Container(
          child: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerification.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}

import 'package:flutter/material.dart';

import 'Next_page.dart';
import 'authentication.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Google Sign In"),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: MaterialButton(
              //color: Colors.orange,
              child: Image.asset('assets/GoogleSignUpDark.png'),
              onPressed: () => signInWithGoogle().whenComplete(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => nextpage(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talkitup/Services/auth_services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'dart:math' as math;

import 'package:talkitup/UI/bg_gradient.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: BgGradient(
        foregroundColor: Colors.transparent,
        bgColor: Colors.black45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: const [
                Text(
                  "Bonjour :)",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Welcome to TalkItUp",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 96,
                ),
              ],
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 60,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SignInButton(
                      Buttons.Google,
                      elevation: 12,
                      text: "Sign in with Google",
                      onPressed: () async {
                        final user = await AuthServices.signInWithGoogle();
                        if (user == null) {
                          Fluttertoast.showToast(msg: 'Error in sign in');
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}

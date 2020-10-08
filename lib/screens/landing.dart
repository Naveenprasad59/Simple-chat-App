import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LandingScreen extends StatelessWidget {

  static String id = 'landing_screen';

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return StreamBuilder<User>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return WelcomeScreen();
            } else {
              return ChatScreen();
            }
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

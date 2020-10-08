import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:message_test/screens/chat_screen.dart';
import 'package:message_test/screens/imageScreen.dart';
import 'package:message_test/screens/landing.dart';
import 'package:message_test/screens/login_screen.dart';
import 'package:message_test/screens/registration_screen.dart';
import 'package:message_test/screens/welcome_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LandingScreen.id ,
      routes: {
        LandingScreen.id:(context) => LandingScreen(),
        LoginScreen.id:(context) => LoginScreen(),
        RegistrationScreen.id:(context) => RegistrationScreen(),
        WelcomeScreen.id:(context) => WelcomeScreen(),
        ChatScreen.id:(context) => ChatScreen(),
        ImageScreen.id:(context) => ImageScreen(),
      },
    );
  }
}

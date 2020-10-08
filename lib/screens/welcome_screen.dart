
import 'package:flutter/material.dart';
import 'package:message_test/components/roundedbutton.dart';
import 'package:message_test/screens/registration_screen.dart';

import 'login_screen.dart';
class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),

    );
    animation = CurvedAnimation(parent: controller,curve: Curves.easeIn);
//    animation.addStatusListener((status) {
//        if(status == AnimationStatus.completed){
//          controller.reverse();
//        }
//        else if(status == AnimationStatus.dismissed){
//          controller.reverse(from: 1.0);
//        }
 //   });
    controller.forward();
    controller.addListener(() {
      setState(() {});
    //  print(controller.value);
    });
  }


  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: controller.value*100,
                  ),
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              text: 'Log In',
              colour: Colors.lightBlueAccent,
              onPress: (){
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              text: 'Register',
              colour: Colors.blue,
              onPress: (){
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}



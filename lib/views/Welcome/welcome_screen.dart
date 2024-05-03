import 'package:flutter/material.dart';
import '../components/rounded_button.dart';
import '../Login/login_screen.dart';
import '../SignUp/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
  body: Stack(
    children: [
      Positioned(
        top: 0,
        left: 0,
        child: Image.asset(
          "assets/images/main_top.png",
          width: size.width * 0.3,
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: Image.asset(
          "assets/images/main_bottom.png",
          width: size.width * 0.2,
        ),
      ),
      Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "WELCOME TO NOTIFY",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 24, fontFamily: 'Roboto Mono',),
              ),
              SizedBox(height: size.height * 0.08),
              Image.asset("assets/images/welcome.png",
              height: size.height * 0.45, ),
              SizedBox(height: size.height * 0.02),
              RoundedButton(
                text: "LOGIN",
                press: () {Navigator.push(context, MaterialPageRoute(builder: (context){return LoginScreen();},),);},
                textColor: Color(0xff705f93),
                color: Colors.blue[50],
              ),
              RoundedButton(
                text: "SIGN UP",
                color: Color(0xFFAC5AD2),
                textColor: Colors.blue[50],
                press: () {Navigator.push(context, MaterialPageRoute(builder: (context){return SignUpScreen();},),);},
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);

  }
}

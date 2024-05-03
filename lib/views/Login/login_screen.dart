import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/views/Home/home_student.dart';
import '../../constants.dart';
import '../Home/home_screen.dart';
import '../SignUp/signup_screen.dart';
import '../components/rounded_button.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State
{
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
bool _passwordVisible = false;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> _signInWithEmailAndPassword(BuildContext context) async {
  try {
    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
      String? role = await _getUserRole(_emailController.text.trim());
      // Redirect based on role
      if (role == 'Student') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeStudent()),
        );
      } else if (role == 'Teacher') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        print('Unknown role for user.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unknown role for user.'),
          ),
        );
      }
  } catch (e) {
    print("Failed to sign in: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Failed to sign in. Please check your email and password."),
      ),
    );
  }
}


Future<String?> _getUserRole(String email) async {
  try {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firebaseFirestore
        .collection('user')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      String? role = userDoc.get('role');
      return role;
    } else {
      print('User not found with email: $email');
      return null;
    }
  } catch (e) {
    print("Failed to get user role: $e");
    return null;
  }
}

@override
Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Scaffold(
    body: Container(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/login_bottom.png",
              width: size.width * 0.4,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "LOGIN",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      fontSize: 24,
                      fontFamily: 'Roboto Mono',
                    ),
                  ),
                  Image.asset(
                    "assets/images/login.png",
                    height: size.height * 0.35,
                  ),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 223, 210, 240),
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email, color: kPrimaryColor,),
                        hintText: "Your Email",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 223, 210, 240),
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: kPrimaryColor,),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        hintText: "Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  RoundedButton(
                    text: "LOGIN",
                    color: Colors.blue[50],
                    textColor: Colors.purple,
                    press: () => _signInWithEmailAndPassword(context),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an Account ? ",
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          Text(
                            "Sign UP",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
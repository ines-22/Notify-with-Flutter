import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Login/login_screen.dart';
import '../components/rounded_button.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State
{
final TextEditingController _nameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
bool _passwordVisible = false;
String? _selectedRole;
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<void> _signUpWithGoogle() async {
    try {
      // Trigger Google sign-in flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // Get Google authentication credentials
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Sign in to Firebase with Google credentials
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        // Optionally, update the user's display name
        await userCredential.user!.updateDisplayName(_nameController.text.trim());
        // Navigate to home screen after successful sign-up
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      // Handle sign-up with Google errors
      print("Failed to sign up with Google: $e");
      // Show a snackbar with a generic error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign up with Google. Please try again later.'),
        ),
      );
    }
  }

Future<void> _signUpWithEmailAndPassword(BuildContext context) async {
  
  if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select your role.'),
        ),
      );
      return;
    }

  try {
    // Check if email is in the required format
    if (!_isValidEmail(_emailController.text.trim())) {
      // Show a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address.'),
        ),
      );
      return; // Exit the function
    }

    // Check if password is less than 6 characters
    if (_passwordController.text.trim().length < 6) {
      // Show a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be at least 6 characters long.'),
        ),
      );
      return; // Exit the function
    }

    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

     // Get the Firebase user object
      User? user = userCredential.user;

    if (user != null) {
        await postDetailsToFirestore(_emailController.text, _selectedRole!);
      }

    // Optionally, you can update the user's display name
    await userCredential.user!.updateDisplayName(_nameController.text.trim());
    
    // Navigate to login screen after successful sign-up
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  } catch (e) {
    if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
      // Handle sign-up error when email already exists
      print('The account already exists for that email.');
      // Show a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The account already exists for that email.'),
        ),
      );
    } else {
      // Handle other sign-up errors here
      print("Failed to sign up: $e");
      // Show a snackbar with a generic error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign up. Please try again later.'),
        ),
      );
    }
  }
}

Future<void> postDetailsToFirestore(String email, String role) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      CollectionReference ref = firebaseFirestore.collection('user');

      await ref.doc(email).set({
        'email': email,
        'role': role,
      });
    } catch (e) {
      print("Error posting details to Firestore: $e");
    }
  }
// Function to validate email format
bool _isValidEmail(String email) {
  // Regular expression pattern for email validation
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
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
              width: size.width * 0.25,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      fontSize: 24,
                      fontFamily: 'Roboto Mono',
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Image.asset(
                    "assets/images/signup.png",
                    height: size.height * 0.25,
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.person, color: kPrimaryColor,),
                        hintText: "Your Name",
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
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 223, 210, 240),
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedRole,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                      items: ['Student', 'Teacher'].map<DropdownMenuItem<String>>((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Select Role',
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  RoundedButton(
                    text: "SIGN UP",
                    color: Colors.blue[50],
                    textColor: Colors.purple,
                    press:() => _signUpWithEmailAndPassword(context), // Call sign-up function
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have an Account ? ",
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          Text(
                            "LOGIN",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: _signUpWithGoogle,
                    icon: Icon(Icons.email, color: Colors.purple), // Gmail icon
                    label: Text("Sign up with Gmail"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.purple,
                      backgroundColor: Colors.white, // Button color
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: BorderSide(color: Colors.purple), // Border color
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
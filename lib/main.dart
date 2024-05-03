import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'controllers/push_notif.dart';
import 'views/Welcome/welcome_screen.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
                apiKey: 'AIzaSyCTmLRffPtsadde_l7mSdIo-wzPRTgHocg',
                appId: '1:618219324765:android:f66cff06b52beaefe054b4',
                messagingSenderId: '618219324765',
                projectId: 'fir-flutter-codelab-2bc70'),);
                 // Initialize Firebase
 FirebaseApi firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();
  
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notify',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WelcomeScreen(),
    );
  }
}
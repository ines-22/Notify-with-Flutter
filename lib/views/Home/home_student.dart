import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../controllers/notifpush.dart';
import '../Category/subscribedCategoryScreen.dart';
import '../Message/messageStudent.dart';
import '../Welcome/welcome_screen.dart';
class HomeStudent extends StatefulWidget {
  @override
  _HomeStudentState createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudent> {
  List<String> subscribedCategories = [];
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  void _configureFirebase() {
    PushNotifications.init();
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
    _handleBackgroundNotificationTapped();
    _handleForegroundNotifications();
  }

  void _handleBackgroundNotificationTapped() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("Background Notification Tapped");
      }
    });
  }

  void _handleForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String payloadData = jsonEncode(message.data);
      print("Got a message in foreground");
      if (message.notification != null) {
        PushNotifications.showSimpleNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            payload: payloadData);
      }
   
    });
  }

  // Firebase background message handler
  Future<void> _firebaseBackgroundMessage(RemoteMessage message) async {
    print("Message from push notification is ${message.data}");
    String payloadData = jsonEncode(message.data);
    PushNotifications.showSimpleNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
        payload: payloadData);
  }
  @override
  void initState() {
    super.initState();
    _fetchSubscribedCategories();
    _configureFirebase() ;
  }

  Future<void> _fetchSubscribedCategories() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.email)
            .get();
        setState(() {
          subscribedCategories = List<String>.from(userSnapshot['subscribedCategories'] ?? []);
        });
      }
    } catch (error) {
      print('Error fetching subscribed categories: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: buildAppBar(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('category').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final categories = snapshot.data!.docs;
          List<DocumentSnapshot> nonSubscribedCategories = categories.where((category) {
            final categoryName = category['name'] as String;
            return !subscribedCategories.contains(categoryName);
          }).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: nonSubscribedCategories.length,
                  itemBuilder: (context, index) {
                    final category = nonSubscribedCategories[index];
                    final categoryName = category['name'] as String;
                    return Container(
                      color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                      child: ListTile(
                        leading: Text((index+1).toString()),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(categoryName),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  subscribedCategories.add(categoryName);
                                });
                                _subscribeUserToCategory(categoryName);
                              },
                              child: Text('Subscribe'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 224, 204, 227),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeStudent()),
                    );},
                ),
                Text('Home'),
              ],
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.category),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubscribedCategoriesScreen()),
                    );
                  },
                ),
                Text('Categories'),
              ],
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MessageStudentScreen()),
                    );
                  },
                ),
                Text('Messages'),
              ],
            ),

            
          ],
        ),
      ),
    );
  }

  Future<void> _subscribeUserToCategory(String categoryName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance.collection('user').doc(user.email).update({
          'subscribedCategories': FieldValue.arrayUnion([categoryName]),
        });
      }
    } catch (e) {
      print('Error subscribing user to category: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to subscribe to category. Please try again later.'),
        ),
      );
    }
  }

  Widget buildAppBar() {
    // Retrieve the currently authenticated user
    User? user = FirebaseAuth.instance.currentUser;

    // Get the uppercase version of the user's display name
    String userName = user?.displayName?.toUpperCase() ?? "GUEST";

    return AppBar(
      title: Text(
        'Welcome To Notify',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color.fromARGB(255, 218, 197, 221),
      actions: [
        Text(
          userName,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()),
            );
          },
          icon: Icon(Icons.logout),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
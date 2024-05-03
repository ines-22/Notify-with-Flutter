import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Category/subscribedCategoryScreen.dart';
import '../Home/home_student.dart';
import '../Welcome/welcome_screen.dart';

class MessageStudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: buildAppBar(),
      ),
      body: MessageList(),
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

   Widget buildAppBar() {
    // Retrieve the currently authenticated user
    User? user = FirebaseAuth.instance.currentUser;

    // Get the uppercase version of the user's display name
    String userName = user?.displayName?.toUpperCase() ?? "GUEST";

    return AppBar(
      title: Text(
        'Messages',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color.fromARGB(255, 218, 197, 221),
      
    );
  }
}

class MessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('messages').orderBy('priority').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = snapshot.data!.docs;
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index].data() as Map<String, dynamic>;
            return Container(
              color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
              child: ListTile(
                leading: Text((index+1).toString()),
              title: Text('Object: ${message['object']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category: ${message['categories'].join(', ')}'),
                  Text('Text: ${message['text']}'),
                  Text('Priority: ${message['priority']}'),
                ],
              ),
            ),
            );
          },
        );
      },
    );
  }
}

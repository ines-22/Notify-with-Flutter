import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import '../Category/categoryScreen.dart';
import '../../controllers/message_controller.dart';
import '../Home/home_screen.dart';
import '/models/message.dart';
import 'messageCreate_screen.dart';
import 'messageUpdate_screen.dart';

class MessageListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    String? userEmail = user?.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 218, 197, 221),
        title: Text(
          'Message List',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Text(
            " add message ",
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateMessageScreen()),
              );
            },
            icon: Icon(Icons.add),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: StreamBuilder<List<Message>>(
        stream: MessageService().getAllMessages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<Message> messages = snapshot.data ?? [];
          return ListView.builder(
            itemCount: messages.length + 1, 
            itemBuilder: (context, index) {
              if (index == 0) {
                return SizedBox(height: 20); 
              }
              Message message = messages[index - 1];
              return Container(
                color: index % 2 == 0 ? Colors.white : Colors.grey[200], 
                child: ListTile(
                  leading: Text((index).toString()), 
                 title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Object: ${message.object}'),
                      Text('Category: ${message.categories}'),
                      Text('Text: ${message.text}'),
                      Text('Priority: ${message.priority}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateMessageScreen(message: message)),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          MessageService().deleteMessage(message.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
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
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
                Text('Home'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.category),
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryListScreen()));},
                ),
                Text('Categorie'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => MessageListScreen()));}, // No need to navigate to MessageListScreen again
                ),
                Text('Message'),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}

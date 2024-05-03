import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gtk_flutter/views/Welcome/welcome_screen.dart';
import '../Category/categoryScreen.dart';
import '../Message/message_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userName = user?.displayName?.toUpperCase() ?? "GUEST";
    Size size = MediaQuery.of(context).size;
  Widget buildCategoryButton(String label, VoidCallback onPressed) {
  return Container(
    height: size.height * 0.15,
    width: size.width * 0.5,
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 180, 207, 224),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(label, style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    ),
  );
}

    // Function to build the app bar
    Widget buildAppBar() {
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
              Navigator.push(context, MaterialPageRoute(builder: (context){return WelcomeScreen();},),);
            },
            icon: Icon(Icons.logout),
          ),
          SizedBox(width: 10),
        ],
      );
    }

Widget buildContent(BuildContext context) {
  return Stack(
    children: [
      Positioned(
        top: kToolbarHeight + 20,
        left: 40,
        right: 40,
        child: Text(
          'Pick Up an option',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCategoryButton('Categories', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryListScreen()),
              );
              
            }),
            SizedBox(height: 10),
            buildCategoryButton('Messages', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessageListScreen()),
              );
            }),
          ],
        ),
      ),
    ],
  );
}
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: buildAppBar(),
      ),
      backgroundColor: Colors.white,
      body: buildContent(context),
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
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context){return HomePage();},),);},
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
                    MaterialPageRoute(builder: (context) => CategoryListScreen()),
                  );
              },
                ),
                Text('Categorie'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context){return MessageListScreen();},),);},
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

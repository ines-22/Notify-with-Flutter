import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Home/home_student.dart';
import '../Message/messageStudent.dart';


class SubscribedCategoriesScreen extends StatefulWidget {
  @override
  _SubscribedCategoriesScreenState createState() =>
      _SubscribedCategoriesScreenState();
}

class _SubscribedCategoriesScreenState
    extends State<SubscribedCategoriesScreen> {
  late User currentUser;
  List<String> subscribedCategories = [];

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    _fetchSubscribedCategories();
  }

  Future<void> _fetchSubscribedCategories() async {
    try {
      final userData =
          await FirebaseFirestore.instance.collection('user').doc(currentUser.email).get();
      final data = userData.data() as Map<String, dynamic>;
      setState(() {
        subscribedCategories = List<String>.from(data['subscribedCategories']);
      });
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
      body: _buildCategoryList(),
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
  
  void _unsubscribeFromCategory(String categoryName) async {
  try {
    await FirebaseFirestore.instance.collection('user').doc(currentUser.email).update({
      'subscribedCategories': FieldValue.arrayRemove([categoryName]),
    });
    setState(() {
      subscribedCategories.remove(categoryName);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Unsubscribed from $categoryName')),
    );
  } catch (error) {
    print('Error unsubscribing from category: $error');
  }
}


  Widget buildAppBar() {
    User? user = FirebaseAuth.instance.currentUser;
    String userName = user?.displayName?.toUpperCase() ?? "GUEST";

    return AppBar(
      title: Text(
        'Subscribed Categories',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color.fromARGB(255, 218, 197, 221),
      
    );
  }
Widget _buildCategoryList() {
  return ListView.builder(
    itemCount: subscribedCategories.length,
    itemBuilder: (context, index) {
      final categoryName = subscribedCategories[index];
      return Container(
        color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
        child: ListTile(
          leading: Text((index+1).toString()),
          title: Row(
            children: [
              Expanded(
                child: Text(categoryName),
              ),
              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  _unsubscribeFromCategory(categoryName);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
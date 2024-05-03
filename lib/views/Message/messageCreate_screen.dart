import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Category/categoryScreen.dart';
import '/models/message.dart';
import '/controllers/message_controller.dart';
import '/controllers/category_controller.dart';
import '../Home/home_screen.dart';
import '../Welcome/welcome_screen.dart';
import 'message_screen.dart';

class CreateMessageScreen extends StatefulWidget {
  @override
  _CreateMessageScreenState createState() => _CreateMessageScreenState();
}

class _CreateMessageScreenState extends State<CreateMessageScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _objectController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();

  List<String> categoryList = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    getCategoryList();
  }

  void getCategoryList() async {
    CategoryService().getAllCategories().listen((snapshot) {
      setState(() {
        categoryList = snapshot.map((category) => category.name).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 218, 197, 221),
        title: Text(
          'Create Message ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _objectController,
                decoration: InputDecoration(labelText: 'Object'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter object';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categoryList.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _textController,
                decoration: InputDecoration(labelText: 'Text'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priorityController,
                decoration: InputDecoration(labelText: 'Priority'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter priority';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Message newMessage = Message(
                        id: FirebaseFirestore.instance
                            .collection('messages')
                            .doc()
                            .id,
                        object: _objectController.text,
                        categories: [selectedCategory!], 
                        text: _textController.text,
                        priority: int.parse(_priorityController.text),
                      );

                      try {
                        await MessageService().createMessage(newMessage);
                        Navigator.pop(context); 
                      } catch (e) {
                        // Handle error if needed
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Failed to create message: $e'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: Text('Create Message'),
                ),
              ),
            ],
          ),
        ),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomePage();
                        },
                      ),
                    );
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
                  onPressed: () {  
                  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryListScreen()),
              );},
                ),
                Text('Category'),
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
                      MaterialPageRoute(
                        builder: (context) {
                          return MessageListScreen();
                        },
                      ),
                    );
                  },
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

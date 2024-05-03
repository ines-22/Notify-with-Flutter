import 'package:flutter/material.dart';
import '../Category/categoryScreen.dart';
import '../../models/message.dart';
import '../../controllers/message_controller.dart';
import '../../controllers/category_controller.dart'; // Import the CategoryService
import '../Home/home_screen.dart';
import '../Welcome/welcome_screen.dart';
import 'message_screen.dart';

class UpdateMessageScreen extends StatefulWidget {
  final Message message;

  const UpdateMessageScreen({required this.message});

  @override
  _UpdateMessageScreenState createState() => _UpdateMessageScreenState();
}

class _UpdateMessageScreenState extends State<UpdateMessageScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _objectController;
  late TextEditingController _textController;
  late TextEditingController _priorityController;

  List<String> categoryList = [];
  late List<String> selectedCategories;

  @override
  void initState() {
    super.initState();
    getCategoryList();
    _objectController = TextEditingController(text: widget.message.object);
    _textController = TextEditingController(text: widget.message.text);
    _priorityController =
        TextEditingController(text: widget.message.priority.toString());
    selectedCategories = List.from(widget.message.categories);
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
          'Update Message',
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
                value: selectedCategories.isNotEmpty
                    ? selectedCategories[0]
                    : null,
                items: categoryList.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedCategories = [value!];
                  });
                },
                decoration: InputDecoration(labelText: 'Categories'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select at least one category';
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Message updatedMessage = Message(
                        id: widget.message.id,
                        object: _objectController.text,
                        categories: selectedCategories,
                        text: _textController.text,
                        priority: int.parse(_priorityController.text),
                      );

                      MessageService().updateMessage(
                          widget.message.id, updatedMessage);
                      Navigator.pop(context); 
                    }
                  },
                  child: Text('Update Message'),
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

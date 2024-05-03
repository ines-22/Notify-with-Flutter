import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import '../../controllers/category_controller.dart';
import '../../models/category.dart';
import '../Home/home_screen.dart';
import '../Message/message_screen.dart';


class CategoryListScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    String? userEmail = user?.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 218, 197, 221),
        title: Text(
          'Category List',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<Category>>(
        stream: CategoryService().getAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<Category> categories = snapshot.data ?? [];
          return ListView.builder(
            itemCount: categories.length + 1, 
            itemBuilder: (context, index) {
              if (index == 0) {
                return SizedBox(height: 20); 
              }
              Category categorie = categories[index - 1]; 
              return Container(
                color: index % 2 == 0 ? Colors.white : Colors.grey[200], 
                child: ListTile(
                  leading: Text((index).toString()),
                  title: Text(categorie.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showCategoryDialogUpdate(context, categorie);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          CategoryService().deleteCategory(categorie.id);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCategoryDialogCreate(context);
        },
        child: Icon(Icons.add),
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
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => MessageListScreen()));}, 
                ),
                Text('Message'),
              ],
            ),
            
          ],
        ),
      ),
    );
  }

Future<void> _showCategoryDialogCreate(BuildContext context) async {
  // Clear the text field before showing the dialog
  _nameController.clear();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('New Category'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter category name';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Category newCategory = Category(
                  id: FirebaseFirestore.instance
                          .collection('category')
                          .doc()
                          .id, 
                  name: _nameController.text);
                CategoryService().createCategory(newCategory);
                Navigator.of(context).pop();
              }
            },
            child: Text('Create'),
          ),
        ],
      );
    },
  );
}

Future<void> _showCategoryDialogUpdate(BuildContext context, Category category) async {
  _nameController.text = category.name;

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Update Category'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter category name';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Category updatedCategory = Category(
                  id: category.id, // Keep the same ID
                  name: _nameController.text,
                );
                CategoryService().updateCategory(category.id, updatedCategory);
                Navigator.of(context).pop();
              }
            },
            child: Text('Update'),
          ),
        ],
      );
    },
  );
}

}

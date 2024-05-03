import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/category.dart';
class CategoryService {
  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('category');

  // Create a new category
  Future<void> createCategory(Category category, {String? id}) async {
  try {
    if (id != null) {
      await categoriesCollection.doc(id).set({
        'name': category.name,
      });
    } else {
      await categoriesCollection.add({
        'name': category.name,
      });
    }
  } catch (e) {
    print('Error creating category: $e');
  }
}


  // Read all categories
  Stream<List<Category>> getAllCategories() {
    return categoriesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Category(
          id: doc.id,
          name: doc['name'],
        );
      }).toList();
    });
  }

  // Update an existing category
  Future<void> updateCategory(String id, Category newCategory) async {
    try {
      await categoriesCollection.doc(id).update({
        'name': newCategory.name,
      });
    } catch (e) {
      print('Error updating category: $e');
    }
  }

  // Delete a category
  Future<void> deleteCategory(String id) async {
    try {
      await categoriesCollection.doc(id).delete();
    } catch (e) {
      print('Error deleting category: $e');
    }
  }
}
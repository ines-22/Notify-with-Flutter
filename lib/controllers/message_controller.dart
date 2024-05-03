import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/message.dart';

class MessageService {
  final CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('messages');

  // Create a new message
  Future<void> createMessage(Message message) async {
    try {
      await messagesCollection.add({
        'object' : message.object,
        'categories': message.categories, // No need to convert categories to JSON
        'text': message.text,
        'priority': message.priority,
      });
    } catch (e) {
      print('Error creating message: $e');
    }
  }

  // Read all messages
  Stream<List<Message>> getAllMessages() {
    return messagesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message(
          id: doc.id,
          object: doc['object'],
          categories: List<String>.from(doc['categories']), // Convert to list of strings directly
          text: doc['text'],
          priority: doc['priority'],
        );
      }).toList();
    });
  }

  // Retrieve messages based on subscribed categories
  Stream<List<Message>> getMessagesBySubscribedCategories(List<String> subscribedCategories) {
    return messagesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        List<String> categories = List<String>.from(doc['categories']);
        return Message(
          id: doc.id,
          object: doc['object'],
          categories: categories,
          text: doc['text'],
          priority: doc['priority'],
        );
      }).where((message) => _hasSubscribedCategory(message, subscribedCategories)).toList();
    });
  }



  // Helper function to check if a message has any subscribed category
  bool _hasSubscribedCategory(Message message, List<String> subscribedCategories) {
    for (String category in message.categories) {
      if (subscribedCategories.contains(category)) {
        print("yess");
        return true;
      }
    }
    print("No");
    return false;
  }

  // Update an existing message
  Future<void> updateMessage(String id, Message newMessage) async {
    try {
      await messagesCollection.doc(id).update({
        'object': newMessage.object,
        'categories': newMessage.categories, // No need to convert categories to JSON
        'text': newMessage.text,
        'priority': newMessage.priority,
      });
    } catch (e) {
      print('Error updating message: $e');
    }
  }

  // Delete a message
  Future<void> deleteMessage(String id) async {
    try {
      await messagesCollection.doc(id).delete();
    } catch (e) {
      print('Error deleting message: $e');
    }
  }
}

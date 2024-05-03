
class Message {
  String id;
  String object;
  List<String> categories; // Change to list of strings
  String text;
  int priority;

  Message({
    required this.id,
    required this.object,
    required this.categories,
    required this.text,
    required this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'object': object,
      'categories': categories, // No need to convert to JSON, as it's now a list of strings
      'text': text,
      'priority': priority,
    };
  }

  factory Message.fromJson(Map<String, dynamic> data, String id) {
    // categories is now a list of strings, no conversion needed
    List<String> categoriesList = List<String>.from(data['categories']);

    return Message(
      id: id,
      object: data['object'],
      categories: categoriesList,
      text: data['text'],
      priority: data['priority'],
    );
  }
}

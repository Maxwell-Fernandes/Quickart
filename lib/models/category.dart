import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id; // Add this line for the category ID
  final String name;
  final String imageUrl;

  Category({
    required this.id, // Add this line
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id, // Get the document ID from Firestore
      name: data['category_name'] ?? '',
      imageUrl: data['image_url'] ?? '',
    );
  }
}

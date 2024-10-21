import 'package:cloud_firestore/cloud_firestore.dart';

// Item model to represent individual items in the cart
class Item {
  final String productId; // ID of the product
  int quantity; // Quantity of the product
  final double price; // Price of the product
  final String productName; // Name of the product
  final String imageUrl; // URL of the product image

  Item({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.productName, // Add productName
    required this.imageUrl, // Add imageUrl
  });

  // Method to convert Firestore map to Item object
  factory Item.fromMap(Map<String, dynamic> data) {
    return Item(
      productId: data['product_id'] ?? '',
      quantity: data['quantity']?.toInt() ?? 0,
      price: data['price']?.toDouble() ?? 0.0,
      productName:
          data['product_name'] ?? 'Unknown Product', // Fetch product name
      imageUrl: data['image_url'] ?? '', // Fetch image URL
    );
  }

  // Method to convert Item object to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'product_name': productName,
      'image_url': imageUrl,
    };
  }
}

class Cart {
  final String userId; // The ID of the user
  final List<Item> items; // List of items in the cart
  final Timestamp createdAt; // Timestamp for creation
  final Timestamp updatedAt; // Timestamp for last update
  final double totalAmount; // Total amount for the cart

  Cart({
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    required this.totalAmount,
  });

  // Method to convert Firestore document data to Cart object
  factory Cart.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return Cart(
      userId: data['user_id'] ?? '',
      items: List<Item>.from(data['items'].map((item) => Item.fromMap(item))),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
      totalAmount: data['total_amount']?.toDouble() ?? 0.0,
    );
  }

  // Method to convert Cart object to Firestore document data
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'total_amount': totalAmount,
    };
  }
}

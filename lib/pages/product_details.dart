import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickart_proj/theme/color_theme.dart';
import 'package:quickart_proj/widgets/custom_button1.dart'; // Import your custom button

class ProductDetailsPage extends StatefulWidget {
  final String categoryId; // Category ID passed from HomePage
  final String categoryName; // Category Name passed from HomePage

  const ProductDetailsPage({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Future<void> _addToCart(String productId, double price, int quantity) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle user not logged in
      print('User is not logged in');
      return;
    }

    final userId = user.uid;

    // Check if cart document already exists
    final cartDocRef =
        FirebaseFirestore.instance.collection('carts').doc(userId);
    final cartSnapshot = await cartDocRef.get();

    // Prepare the new item
    final newItem = {
      'product_id': productId,
      'price': price,
      'quantity': quantity,
    };

    if (cartSnapshot.exists) {
      // If the document exists, update the items array
      await cartDocRef.update({
        'items': FieldValue.arrayUnion([newItem]),
        'updatedAt': FieldValue.serverTimestamp(), // Update the timestamp
        'total_amount':
            FieldValue.increment(price * quantity), // Update the total amount
      });
    } else {
      // If the document does not exist, create a new one
      await cartDocRef.set({
        'user_id': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'items': [newItem],
        'total_amount': price * quantity, // Set the initial total amount
      });
    }

    print('Added item to cart: $newItem');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: widget.categoryId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data?.docs ?? [];

          return products.isEmpty
              ? const Center(child: Text('No products available.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.65, // Adjusted to give more height
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final product = products[index];
                    final imageUrl = product['image_url'] ?? '';
                    final productName = product['product_name'] ?? 'Unknown';
                    final price = (product['price'] ?? 0).toDouble();

                    // Local quantity state for each product
                    int _quantity = 1;

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 8,
                          shadowColor: Colors.black26,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15.0),
                                  ),
                                  child: imageUrl.isNotEmpty
                                      ? FadeInImage(
                                          placeholder: const AssetImage(
                                              'images/loading.gif'),
                                          image: NetworkImage(imageUrl),
                                          fit: BoxFit.contain, // Improved fit
                                          fadeInDuration:
                                              const Duration(milliseconds: 300),
                                        )
                                      : const Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '₹$price',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: AppTheme.primaryTextColor),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (_quantity > 1) {
                                            _quantity--;
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red[100],
                                        ),
                                        child: const Icon(Icons.remove,
                                            color: Colors.red),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text(
                                        '$_quantity',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _quantity++;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green[100],
                                        ),
                                        child: const Icon(Icons.add,
                                            color: AppTheme.primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomButton(
                                  text: 'Add to Cart',
                                  onPressed: () {
                                    _addToCart(product['product_id'], price,
                                        _quantity);
                                  },
                                  color: AppTheme.primaryColor,
                                  elevation: 4,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}

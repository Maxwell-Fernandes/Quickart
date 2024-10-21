import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For currency formatting
import 'package:quickart_proj/models/cart_model.dart'; // Import your Cart model
import 'package:quickart_proj/pages/payment_selection.dart'; // Import your payment selection page

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String? userId; // Make userId nullable to handle null cases
  List<Item> cartItems = []; // List to store items in the cart
  double totalAmount = 0.0; // Total amount for the cart

  @override
  void initState() {
    super.initState();
    _fetchCart(); // Fetch cart items when the page initializes
  }

  Future<void> _fetchCart() async {
    User? user = FirebaseAuth.instance.currentUser; // Get current user
    if (user != null) {
      userId = user.uid; // Get user ID

      // Listen for cart changes
      FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .snapshots()
          .listen((DocumentSnapshot snapshot) async {
        if (snapshot.exists) {
          Cart cart = Cart.fromFirestore(snapshot);

          // Fetch product details for each item in the cart
          List<Item> updatedCartItems = [];
          for (var item in cart.items) {
            // Fetch product details using the product_id
            DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
                .collection('products')
                .doc(item.productId)
                .get();

            if (productSnapshot.exists) {
              var productData = productSnapshot.data() as Map<String, dynamic>;

              // Create a new item with product details
              updatedCartItems.add(
                Item(
                  productId: item.productId,
                  quantity: item.quantity,
                  price: productData['price']?.toDouble() ?? 0.0,
                  productName: productData['product_name'] ?? 'Unknown Product',
                  imageUrl: productData['image_url'] ??
                      '', // Add image URL if available
                ),
              );
            }
          }

          setState(() {
            cartItems =
                updatedCartItems; // Update cart items with product details
            totalAmount = cart.totalAmount; // Update total amount
          });
        } else {
          setState(() {
            cartItems = [];
            totalAmount = 0.0; // Reset cart items if document does not exist
          });
        }
      });
    }
  }

  double getTotalPrice() {
    return cartItems.fold(
        0, (total, item) => total + (item.price * item.quantity));
  }

  void updateQuantity(int index, int quantity) {
    setState(() {
      // Prevent quantity from going below 1
      cartItems[index].quantity = quantity < 1 ? 1 : quantity;
    });
    _updateCartInFirestore();
  }

  void _updateCartInFirestore() async {
    if (userId != null && userId!.isNotEmpty) {
      // Update cart in Firestore
      await FirebaseFirestore.instance.collection('carts').doc(userId).update({
        'items': cartItems.map((item) => item.toMap()).toList(),
        'total_amount': getTotalPrice(),
        'updatedAt': FieldValue.serverTimestamp(), // Update timestamp
      });
    }
  }

  void removeItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Removal'),
          content: Text('Are you sure you want to remove this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  cartItems.removeAt(index); // Remove item from local list
                });
                _updateCartInFirestore(); // Update Firestore
                Navigator.of(context).pop();
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  String formatCurrency(double amount) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'en_IN', // Set locale to Indian
      symbol: '₹', // Set currency symbol to Indian Rupee
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty!'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: cartItems[index].imageUrl.isNotEmpty
                        ? Image.network(cartItems[index].imageUrl,
                            width: 50, height: 50) // Show product image
                        : Icon(Icons
                            .image), // Fallback icon if no image is available
                    title: Text(
                        cartItems[index].productName), // Display product name
                    subtitle: Text(
                      'Price: ${formatCurrency(cartItems[index].price)} x ${cartItems[index].quantity}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => updateQuantity(
                            index,
                            cartItems[index].quantity > 1
                                ? cartItems[index].quantity - 1
                                : 1,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(cartItems[index].quantity.toString()),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => updateQuantity(
                              index, cartItems[index].quantity + 1),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => removeItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${formatCurrency(getTotalPrice())}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  if (cartItems.isNotEmpty) {
                    // Navigate to checkout
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentSelectionPage()),
                    );
                  }
                },
                child: Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

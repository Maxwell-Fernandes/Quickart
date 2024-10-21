import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  int _quantity = 1; // Default quantity
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  void _incrementQuantity() {
    _controller.forward().then((_) {
      setState(() {
        _quantity++;
      });
      _controller.reverse();
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      _controller.forward().then((_) {
        setState(() {
          _quantity--;
        });
        _controller.reverse();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.blueAccent, // Modern color for the app bar
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
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final product = products[index];
                    final imageUrl = product['image_url'] ?? '';
                    final productName = product['product_name'] ?? 'Unknown';
                    final price = product['price'] ?? 0;

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
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.0)),
                              child: imageUrl.isNotEmpty
                                  ? FadeInImage(
                                      placeholder: AssetImage(
                                          'images/loading.gif'), // Loading placeholder
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                      fadeInDuration:
                                          const Duration(milliseconds: 300),
                                    )
                                  : const Icon(Icons.image_not_supported),
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
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: _decrementQuantity,
                                  child: ScaleTransition(
                                    scale: _controller,
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
                                ),
                                Text(
                                  '$_quantity',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                GestureDetector(
                                  onTap: _incrementQuantity,
                                  child: ScaleTransition(
                                    scale: _controller,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green[100],
                                      ),
                                      child: const Icon(Icons.add,
                                          color: Colors.green),
                                    ),
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
                                // Handle adding to cart with the selected quantity
                                print(
                                    'Added $productName (Qty: $_quantity) to cart');
                              },
                              color: Colors
                                  .blue, // Optional: change the color if needed
                              elevation: 4,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}

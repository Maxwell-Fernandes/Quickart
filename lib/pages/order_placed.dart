import 'package:flutter/material.dart';

// not implemented yet
class OrderPlacedPage extends StatelessWidget {
  const OrderPlacedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.green[200], // Background color for the top section
      body: Column(
        children: [
          // Top Section with image and message
          Container(
            color: Colors.green,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/vegetables.jpg', // Replace with your image path
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                // Order Placed Text
                const Text(
                  'Your Order is placed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtext
                const Text(
                  'Thank you for shopping with us',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Order Status Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.shopping_bag, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              'Arriving Today',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle track order
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.orange[100],
                          ),
                          child: const Text(
                            'Track Now',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Items List
                  _buildOrderItem(
                    imagePath:
                        'assets/yellow_capsicum.jpg', // Replace with your image path
                    itemName: 'Yellow Capsicum 200g',
                    originalPrice: '₹200',
                    discountedPrice: '₹52',
                    quantity: '1 x 200g',
                  ),
                  const Divider(),
                  _buildOrderItem(
                    imagePath:
                        'assets/cucumber.jpg', // Replace with your image path
                    itemName: 'Cucumber 1Kg',
                    originalPrice: '₹200',
                    discountedPrice: '₹64',
                    quantity: '1 x 1kg',
                  ),
                  const Spacer(),
                  // Continue Shopping Button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(
                            double.infinity, 50), // Full-width button
                      ),
                      onPressed: () {
                        // Handle continue shopping action
                      },
                      child: const Text(
                        'Continue Shopping',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem({
    required String imagePath,
    required String itemName,
    required String originalPrice,
    required String discountedPrice,
    required String quantity,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      originalPrice,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      discountedPrice,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  quantity,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

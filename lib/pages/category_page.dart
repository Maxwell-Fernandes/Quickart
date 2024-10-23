// lib/pages/category_page.dart
import 'package:flutter/material.dart';
import 'package:quickart_proj/models/category.dart'; // Import your Category model
import 'package:quickart_proj/pages/product_details.dart';
import 'package:quickart_proj/widgets/category_card.dart'; // Import the CategoryCard widget
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('category').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching categories. Please try again.'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No categories found.'));
          }

          // Map Firestore documents to Category objects
          final categories = snapshot.data!.docs.map((doc) {
            final category = Category.fromDocument(doc);
            return category;
          }).toList();

          // Display categories in a GridView
          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              crossAxisSpacing: 10.0, // Spacing between columns
              mainAxisSpacing: 10.0, // Spacing between rows
              childAspectRatio: 3 / 2, // Aspect ratio for the cards
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryCard(
                title: category.name,
                imagePath: category.imageUrl,
                cardSize: 100.0, // Size of the card
                onTap: () {
                  // Navigate to ProductDetailsPage with the selected category
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(
                        categoryId: category.id,
                        categoryName: category.name,
                      ),
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

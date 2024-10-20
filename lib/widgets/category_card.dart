// lib/widgets/category_card.dart
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap; // Add this line for the onTap callback

  const CategoryCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.onTap, // Accept the callback in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Call the onTap when tapped
      child: Card(
        child: Column(
          children: [
            Image.network(imagePath,
                height: 100, width: 100), // Use Image.network for images
            Text(title),
          ],
        ),
      ),
    );
  }
}

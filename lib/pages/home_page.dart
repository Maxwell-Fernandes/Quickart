import 'package:flutter/material.dart';
import 'package:quickart_proj/widgets/category_card.dart'; // Import the CategoryCard widget
import 'package:quickart_proj/widgets/custom_navbar.dart'; // Import your custom navigation bar
import 'package:quickart_proj/pages/cart.dart';
import 'package:quickart_proj/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:quickart_proj/models/category.dart'; // Import the Category model
import 'package:quickart_proj/pages/product_details.dart'; // Import the ProductDetailsPage
import 'package:quickart_proj/pages/notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Build the page dynamically based on the selected index
  Widget _getPage() {
    switch (_selectedIndex) {
      case 0: // Home
        return _buildHomePageContent(); // Build the dynamic content
      case 1: // Search
        return const Center(child: Text('Search Page'));
      case 2: // Cart
        return CartPage(); // Navigate to CartPage when index is 2
      case 3: // Profile
        return const ProfilePage();
      default:
        return _buildHomePageContent(); // Fallback to home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 ? _buildHomeAppBar() : null,
      body: _getPage(),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // Update the IconButton to navigate to the NotificationPage
  PreferredSizeWidget _buildHomeAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150.0),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        flexibleSpace: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.green,
                            size: 30,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Location',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '32 Llanberis Close, Tonteg, CF38 1HR',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Navigate to NotificationPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationPage()),
                        );
                      },
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Anything',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dynamically build the home page content with categories from Firestore
  Widget _buildHomePageContent() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('category').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
              child: Text('Error fetching categories. Please try again.'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No categories found.'));
        }

        // Map Firestore documents to Category objects
        final categories = snapshot.data!.docs.map((doc) {
          final category = Category.fromDocument(doc);
          return category;
        }).toList();

        // Build the GridView with the fetched categories
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              title: category.name,
              imagePath: category.imageUrl,
              onTap: () {
                print(
                    'Navigating to ProductDetailsPage with categoryId: ${category.id}');
                // Navigate to ProductDetailsPage on tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(
                      categoryId: category.id,
                      categoryName: category.name, // Pass categoryId and name
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

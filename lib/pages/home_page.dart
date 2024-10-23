import 'package:flutter/material.dart';
import 'package:quickart_proj/pages/category_page.dart';
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
        return const CategoryPage();
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
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text(
        'Quickart',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            // Navigate to NotificationPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationPage()),
            );
          },
          icon: const Icon(
            Icons.notifications_outlined,
            color: Colors.black,
            size: 30,
          ),
        ),
      ],
    );
  }

  // Dynamically build the home page content with categories from Firestore
  // Dynamically build the home page content with categories and products from Firestore
  Widget _buildHomePageContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationAndSearch(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildCategoryList(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'All Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildProductList(), // New method to build product list
        ],
      ),
    );
  }

// Build the product list fetched from Firestore
  Widget _buildProductList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
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
                shrinkWrap: true, // Important to prevent layout overflow
                physics:
                    const NeverScrollableScrollPhysics(), // Disable grid scrolling
                padding: const EdgeInsets.all(10.0),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75, // Adjusted to give more height
                ),
                itemBuilder: (BuildContext context, int index) {
                  final product = products[index];
                  final imageUrl = product['image_url'] ?? '';
                  final productName = product['product_name'] ?? 'Unknown';
                  final price = (product['price'] ?? 0).toDouble();

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
                                    placeholder:
                                        const AssetImage('images/loading.gif'),
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.contain,
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '₹$price',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
      },
    );
  }

  // Build the location and search bar
  // Build the location and search bar
  Widget _buildLocationAndSearch() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // Action when location is clicked, such as opening a map
              print('Location clicked!');
              // You could also navigate to a new page for selecting a new location, e.g.:
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => LocationSelectionPage()),
              // );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.green,
                  size: 30,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
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
              ],
            ),
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
    );
  }

  // Build the horizontal list of categories
  Widget _buildCategoryList() {
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

        // Build the ListView with the fetched categories
        return SizedBox(
          height: 120.0, // Set the height for the horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CategoryCard(
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
                          categoryName:
                              category.name, // Pass categoryId and name
                        ),
                      ),
                    );
                  },
                  cardSize: 100.0, // Smaller card size
                ),
              );
            },
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickart_proj/pages/login_page.dart'; // Adjust the import based on your project structure

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'More',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // User Profile Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                        'assets/profile_picture.jpg'), // Replace with your image path
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jack',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'XXXXXXXXXX',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // Navigate to edit profile page
                    },
                    icon: const Icon(Icons.edit),
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Options List
            _buildProfileOption(
              icon: Icons.location_on,
              title: 'My Address',
              onTap: () {
                // Navigate to My Address page
              },
            ),
            _buildProfileOption(
              icon: Icons.shopping_bag,
              title: 'My Orders',
              onTap: () {
                // Navigate to My Orders page
              },
            ),
            _buildProfileOption(
              icon: Icons.favorite,
              title: 'My Wishlist',
              onTap: () {
                // Navigate to My Wishlist page
              },
            ),
            _buildProfileOption(
              icon: Icons.chat,
              title: 'Chat with us',
              onTap: () {
                // Navigate to chat page
              },
            ),
            _buildProfileOption(
              icon: Icons.phone,
              title: 'Talk to our Support',
              onTap: () {
                // Handle calling support
              },
            ),
            _buildProfileOption(
              icon: Icons.mail,
              title: 'Mail to us',
              onTap: () {
                // Handle sending mail
              },
            ),
            _buildProfileOption(
              icon: Icons.facebook,
              title: 'Message to Facebook page',
              onTap: () {
                // Handle Facebook messaging
              },
            ),
            _buildProfileOption(
              icon: Icons.logout,
              title: 'Log out',
              onTap: () async {
                await _logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Log out from Firebase
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => const LoginPage()), // Navigate to Login Page
        (Route<dynamic> route) => false, // Remove all previous routes
      );
    } catch (e) {
      // Handle error during logout
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}

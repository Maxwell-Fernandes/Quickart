import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickart_proj/pages/orders_page.dart';
import 'package:quickart_proj/pages/register_screen.dart'; // Adjust the import based on your project structure
import 'package:quickart_proj/models/user_model.dart'; // Make sure to adjust this import path
import 'package:quickart_proj/pages/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userId;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    print("Initializing Profile Page.");
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      // Get the current user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        setState(() {
          userId = currentUser.uid; // Get the UID
        });

        print("Fetching user details for UID: $userId");

        // Fetch user details from Firestore
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('test')
            .doc(userId)
            .get();

        if (snapshot.exists) {
          // Map the Firestore document to UserModel
          userModel =
              UserModel.fromMap(snapshot.data() as Map<String, dynamic>);

          setState(() {}); // Update the UI with the fetched data
        } else {
          print("User document not found.");
        }
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: userModel == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                              'images/profile_picture.png'), // Replace with your image path
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userModel!.name.isNotEmpty
                                    ? userModel!.name
                                    : 'No Name Available',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userModel!.phoneNumber.isNotEmpty
                                    ? userModel!.phoneNumber
                                    : 'No Phone Number Available',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                userModel!.email.isNotEmpty
                                    ? userModel!.email
                                    : 'No Email Available',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfilePage()), // Replace EditProfilePage() with your desired page
                            );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrdersPage()),
                      );

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
            builder: (context) =>
                const RegisterScreen()), // Navigate to Login Page
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

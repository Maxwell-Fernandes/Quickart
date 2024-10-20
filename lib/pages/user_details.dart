// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:quickart_proj/pages/home_page.dart';

// class UserDetailsPage extends StatefulWidget {
//   final String phoneNumber; // Phone number passed from OTP verification page

//   const UserDetailsPage({super.key, required this.phoneNumber});

//   @override
//   _UserDetailsPageState createState() => _UserDetailsPageState();
// }

// class _UserDetailsPageState extends State<UserDetailsPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   bool _isPasswordVisible = false;

//   Future<void> _register() async {
//     String name = _nameController.text.trim();
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//     String confirmPassword = _confirmPasswordController.text.trim();

//     if (name.isEmpty ||
//         email.isEmpty ||
//         password.isEmpty ||
//         confirmPassword.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill in all fields')),
//       );
//       return;
//     }

//     if (password != confirmPassword) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Passwords do not match')),
//       );
//       return;
//     }

//     try {
//       // Store user data in Firestore
//       await FirebaseFirestore.instance.collection('test').add({
//         'name': name,
//         'email': email,
//         'phone': widget.phoneNumber,
//         'password': password, // Hashing recommended
//       });
//       // Navigate to Home Page after registration
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomePage()),
//       );
//     } catch (e) {
//       print("Error occurred: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('An error occurred. Please try again.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("User Details"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               obscureText: !_isPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 suffixIcon: IconButton(
//                   icon: Icon(_isPasswordVisible
//                       ? Icons.visibility
//                       : Icons.visibility_off),
//                   onPressed: () {
//                     setState(() {
//                       _isPasswordVisible = !_isPasswordVisible;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             TextField(
//               controller: _confirmPasswordController,
//               obscureText: !_isPasswordVisible,
//               decoration: const InputDecoration(labelText: 'Confirm Password'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _register,
//               child: const Text('Register'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

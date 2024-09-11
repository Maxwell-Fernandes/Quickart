import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
        borderSide: BorderSide(
      color: Colors.black,
      width: 3,
      style: BorderStyle.solid,
    ));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 237, 236),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage("images/login_page.png"),
              fit: BoxFit.contain,
              color: Color.fromARGB(255, 237, 237, 236),
              colorBlendMode: BlendMode.darken,
            ),
            const Text(
              'Login page',
              style: TextStyle(
                color: Colors.black,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextField(
                style: TextStyle(
                  color: Color.fromARGB(255, 15, 15, 15),
                ),
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 15, 14, 14),
                  ),
                  focusedBorder: border,
                  enabledBorder: border,
                  filled: true,
                  fillColor: Colors.amber,
                ),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

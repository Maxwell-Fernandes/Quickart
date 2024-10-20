import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickart_proj/pages/home_page.dart';
import 'package:quickart_proj/pages/registration_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String verificationid;
  final String phoneNumber; // Add this line
  const OtpVerificationPage(
      {super.key,
      required this.verificationid,
      required this.phoneNumber}); // Update constructor
  @override
  State<OtpVerificationPage> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OtpVerificationPage> {
  TextEditingController otpcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage("images/login_page.png"),
              fit: BoxFit.contain,
              color: Color.fromARGB(255, 255, 255, 255),
              colorBlendMode: BlendMode.darken,
            ),
            const Text(
              'Enter Verification Code',
              style: TextStyle(
                color: Color.fromARGB(255, 56, 71, 78),
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              'We have sent an SMS to:',
              style: TextStyle(
                color: Color.fromARGB(255, 56, 71, 78),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              // Use the passed phoneNumber here
              widget.phoneNumber,
              style: const TextStyle(
                color: Color.fromARGB(255, 56, 71, 78),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextField(
                controller: otpcontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  prefixIcon: Icon(Icons.lock),
                  iconColor: Color.fromARGB(255, 56, 71, 78),
                  hintText: 'Verification Code',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 56, 71, 78),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 240, 241, 243),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationPage()),
                    );
                  },
                  child: const Text(
                    'Resend OTP',
                    style: TextStyle(
                      color: Color.fromARGB(255, 243, 122, 33),
                      fontSize: 15,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Change phone no.',
                    style: TextStyle(
                      color: Color.fromARGB(255, 56, 71, 78),
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 94, 196, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: widget.verificationid,
                              smsCode: otpcontroller.text.toString());
                      FirebaseAuth.instance
                          .signInWithCredential(credential)
                          .then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      });
                    } catch (ex) {
                      debugPrint(ex.toString());
                    }
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

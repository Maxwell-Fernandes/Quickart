import 'package:flutter/material.dart';

class PaymentSelectionPage extends StatefulWidget {
  const PaymentSelectionPage({Key? key}) : super(key: key);

  @override
  _PaymentSelectionPageState createState() => _PaymentSelectionPageState();
}

class _PaymentSelectionPageState extends State<PaymentSelectionPage> {
  String? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Payment Method'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a payment method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildPaymentOption(
              title: 'Credit Card',
              icon: Icons.credit_card,
              value: 'credit_card',
            ),
            _buildPaymentOption(
              title: 'Debit Card',
              icon: Icons.account_balance_wallet,
              value: 'debit_card',
            ),
            _buildPaymentOption(
              title: 'UPI',
              icon: Icons.qr_code_scanner,
              value: 'upi',
            ),
            _buildPaymentOption(
              title: 'Net Banking',
              icon: Icons.language,
              value: 'net_banking',
            ),
            _buildPaymentOption(
              title: 'Cash on Delivery',
              icon: Icons.money,
              value: 'cash_on_delivery',
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize:
                    const Size(double.infinity, 50), // Full-width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (selectedPaymentMethod != null) {
                  // Handle payment processing based on selectedPaymentMethod
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Paying with $selectedPaymentMethod'),
                    ),
                  );
                } else {
                  // Show error if no payment method is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a payment method'),
                    ),
                  );
                }
              },
              child: const Text(
                'Pay Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Radio<String>(
          value: value,
          groupValue: selectedPaymentMethod,
          onChanged: (String? newValue) {
            setState(() {
              selectedPaymentMethod = newValue;
            });
          },
          activeColor: Colors.green,
        ),
      ),
    );
  }
}

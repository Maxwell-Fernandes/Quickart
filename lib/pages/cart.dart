import 'package:flutter/material.dart';
import 'package:quickart_proj/pages/payment_selection.dart';
import 'package:intl/intl.dart'; // Make sure to add this import for currency formatting

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [
    {'name': 'Apples', 'price': 3.0, 'quantity': 1},
    {'name': 'Bananas', 'price': 2.0, 'quantity': 2},
  ];

  double getTotalPrice() {
    return cartItems.fold(
        0, (total, item) => total + (item['price'] * item['quantity']));
  }

  void updateQuantity(int index, int quantity) {
    setState(() {
      cartItems[index]['quantity'] = quantity;
    });
  }

  void removeItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Removal'),
          content: Text('Are you sure you want to remove this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  cartItems.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  String formatCurrency(double amount) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'en_IN', // Set the locale to Indian
      symbol: '₹', // Set the currency symbol to Indian Rupee
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty!'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(cartItems[index]['name']),
                    subtitle: Text(
                      'Price: ${formatCurrency(cartItems[index]['price'])} x ${cartItems[index]['quantity']}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => updateQuantity(
                              index,
                              cartItems[index]['quantity'] > 1
                                  ? cartItems[index]['quantity'] - 1
                                  : 1),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(cartItems[index]['quantity'].toString()),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => updateQuantity(
                              index, cartItems[index]['quantity'] + 1),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => removeItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${formatCurrency(getTotalPrice())}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to checkout
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaymentSelectionPage()),
                  );
                },
                child: Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

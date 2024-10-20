import 'package:flutter/material.dart';
import 'package:quickart_proj/pages/payment_selection.dart';

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
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cartItems[index]['name']),
            subtitle: Text(
                'Price: \$${cartItems[index]['price']} x ${cartItems[index]['quantity']}'),
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
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () =>
                      updateQuantity(index, cartItems[index]['quantity'] + 1),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => removeItem(index),
                ),
              ],
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
              Text('Total: \$${getTotalPrice()}'),
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

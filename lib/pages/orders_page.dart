import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Orders',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Ongoing'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOngoingOrders(),
          _buildHistoryOrders(),
        ],
      ),
    );
  }

  // Widget for Ongoing Orders tab
  Widget _buildOngoingOrders() {
    // Replace this with your actual data check
    bool hasOngoingOrders = false; // Example flag for empty orders

    if (!hasOngoingOrders) {
      return _buildEmptyOrdersView(
        message: "There is no ongoing order right now. You can order from home",
        imagePath: 'images/empty_orders.png', // Replace with your image path
      );
    } else {
      // Replace with actual ongoing orders list
      return const Center(child: Text("Ongoing orders list goes here"));
    }
  }

  // Widget for History Orders tab
  Widget _buildHistoryOrders() {
    // Replace this with your actual data check
    bool hasHistoryOrders = false; // Example flag for empty history

    if (!hasHistoryOrders) {
      return _buildEmptyOrdersView(
        message: "There is no order history available.",
        imagePath: 'images/empty_orders.png', // Replace with your image path
      );
    } else {
      // Replace with actual history orders list
      return const Center(child: Text("Order history list goes here"));
    }
  }

  // Widget to display when there are no orders
  Widget _buildEmptyOrdersView(
      {required String message, required String imagePath}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

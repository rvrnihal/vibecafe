import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> orders = [
      {
        'item': 'Pizza',
        'image': 'images/food4.jpg',
        'date': 'March 15, 2025',
        'status': 'Delivered',
        'price': '₹250',
        'quantity': 1,
        'customization': 'Extra cheese'
      },
      {
        'item': 'Burger',
        'image': 'images/food2.jpg',
        'date': 'March 12, 2025',
        'status': 'Pending',
        'price': '₹150',
        'quantity': 2,
        'customization': 'No onions'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/'); // Navigate to Home Page
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart'); // Navigate to Cart Page
            },
          ),
        ],
      ),//appbar
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(order['image'], width: 60, height: 60, fit: BoxFit.cover),
              ),
              title: Text(
                order['item'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ordered on: ${order['date']}'),
                  Text('Price: ${order['price']}'),
                  Text('Quantity: ${order['quantity']}'),
                  Text('Customization: ${order['customization']}'),
                  Text(
                    'Status: ${order['status']}',
                    style: TextStyle(
                      color: order['status'] == 'Delivered' ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),//orderd history
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cart'); // Reorder goes to Cart
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Reorder'),//reorder option
              ),
            ),
          );
        },
      ),
    );
  }
}

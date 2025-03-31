import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<String, Map<String, dynamic>> cartItems = {};
  double taxPercentage = 0.1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final Map<String, Map<String, dynamic>>? newCartItems =
        ModalRoute.of(context)?.settings.arguments as Map<String, Map<String, dynamic>>?;
    
    if (newCartItems != null && cartItems.isEmpty) {
      setState(() {
        cartItems = Map.from(newCartItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    cartItems.forEach((key, value) {
      totalPrice += (value['price'] as double) * (value['quantity'] as int);
    });

    double taxAmount = totalPrice * taxPercentage;
    double totalWithTax = totalPrice + taxAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: const Color.fromARGB(230, 142, 173, 69),        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushNamed(context, '/'),
          ),
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            onPressed: () => Navigator.pushNamed(context, '/menu'),
          ),
        ],
      ),//appbar
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty!'))//if cart is empty it shows cart is empty
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                String item = cartItems.keys.elementAt(index);//details of food item 
                int quantity = cartItems[item]!['quantity'] as int;
                double price = cartItems[item]!['price'] as double;
                String image = cartItems[item]!['image'] as String;

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.asset(image, width: 50, height: 50, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
                    title: Text(item),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: $quantity x ₹${price.toStringAsFixed(2)}'),
                        Text('Price: ₹${(quantity * price).toStringAsFixed(2)}', 
                             style: const TextStyle(fontWeight: FontWeight.bold)),//quantity and price of food item
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (cartItems[item]!['quantity'] > 1) {
                                cartItems[item]!['quantity'] -= 1;
                              } else {
                                cartItems.remove(item);
                              }
                            });
                          },
                        ),//quantity option with add or remove
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              cartItems[item]!['quantity'] += 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ₹${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: cartItems.isEmpty ? null : () => _proceedToPayment(),
                    child: const Text('Pay Now'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tax (10%): ₹${taxAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Total with Tax: ₹${totalWithTax.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),//total price with tax and paynow button 
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: cartItems.isEmpty ? null : () => _proceedToPayment(),
                  child: const Text('Proceed to Checkout'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: cartItems.isEmpty
                      ? null
                      : () {
                          setState(() {
                            cartItems.clear();
                          });
                        },
                  child: const Text('Clear Cart'),//remove every thing
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _proceedToPayment() {
    if (cartItems.isNotEmpty) {
      List<Map<String, String>> paymentItems = cartItems.entries.map((entry) {
        return {
          'image': entry.value['image'].toString(),
          'text': entry.key,
        };
      }).toList();

      Navigator.pushNamed(context, '/payment', arguments: paymentItems);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty!')),
      );// it navigates to payment page if not the cart is empty
    }
  }
}

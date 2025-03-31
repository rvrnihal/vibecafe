import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MenuWidget();
  }
}

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  MenuWidgetState createState() => MenuWidgetState();
}

class MenuWidgetState extends State<MenuWidget> {
  Map<String, Map<String, dynamic>> cartItems = {};
  Map<String, String> selectedFlavors = {};
  Map<String, List<String>> selectedCustomizations = {};
  Map<String, int> itemQuantity = {};

  final Map<String, List<Map<String, dynamic>>> categories = {
    'Main Course': [
      {'name': 'Sandwiches', 'image': 'images/food5.jpg', 'price': 599.99, 'flavors': ['Cheese', 'Chicken', 'Vegetarian'], 'customizeOptions': ['Extra Cheese', 'Lettuce', 'Tomato', 'Onions']},
      {'name': 'Soups and Salads', 'image': 'images/food9.jpg', 'price': 499.99, 'flavors': ['Tomato', 'Chicken', 'Mixed'], 'customizeOptions': ['Croutons', 'Cheese', 'Olives', 'Extra Dressing']},
      {'name': 'Pasta', 'image': 'images/food1.jpg', 'price': 699.99, 'flavors': ['White Sauce', 'Red Sauce', 'Pesto'], 'customizeOptions': ['Extra Cheese', 'Mushrooms', 'Chicken']},
      {'name': 'Pizza', 'image': 'images/food4.jpg', 'price': 899.99, 'flavors': ['Margherita', 'Pepperoni', 'BBQ Chicken'], 'customizeOptions': ['Extra Cheese', 'Olives', 'Peppers']},
    ],
    'Desserts': [
      {'name': 'Pastries', 'image': 'images/pastries.jpg', 'price': 399.49, 'flavors': ['Chocolate', 'Vanilla', 'Strawberry'], 'customizeOptions': ['Whipped Cream', 'Fruits', 'Nuts']},
      {'name': 'Desserts', 'image': 'images/desserts.jpg', 'price': 499.49, 'flavors': ['Ice Cream', 'Cake', 'Brownie'], 'customizeOptions': ['Sprinkles', 'Cherries', 'Chocolate Sauce']},
      {'name': 'Cheesecake', 'image': 'images/cheesecake.jpg', 'price': 599.49, 'flavors': ['Blueberry', 'Strawberry', 'Classic'], 'customizeOptions': ['Extra Topping', 'Chocolate Drizzle']},
      {'name': 'Waffles', 'image': 'images/waffles.jpg', 'price': 450.00, 'flavors': ['Maple', 'Chocolate', 'Berry'], 'customizeOptions': ['Whipped Cream', 'Banana Slices', 'Nutella']},
    ],
    'Beverages': [
      {'name': 'Coffee', 'image': 'images/coffee.jpg', 'price': 299.99, 'flavors': ['Espresso', 'Cappuccino', 'Latte'], 'customizeOptions': ['Extra Milk', 'Sugar', 'Vanilla']},
      {'name': 'Tea', 'image': 'images/tea.jpg', 'price': 298.49, 'flavors': ['Green Tea', 'Black Tea', 'Herbal Tea'], 'customizeOptions': ['Lemon', 'Honey', 'Ginger']},
      {'name': 'Smoothies', 'image': 'images/smoothie.jpg', 'price': 350.00, 'flavors': ['Berry Blast', 'Mango', 'Banana'], 'customizeOptions': ['Chia Seeds', 'Yogurt', 'Protein Boost']},
      {'name': 'Milkshakes', 'image': 'images/milkshake.jpg', 'price': 400.00, 'flavors': ['Chocolate', 'Vanilla', 'Oreo'], 'customizeOptions': ['Extra Cream', 'Sprinkles', 'Cherry']},
    ],
  };//menu divided into categories

  void _addToCart(Map<String, dynamic> item, String selectedFlavor, List<String> customizations) {
    setState(() {
      int quantity = itemQuantity[item['name']] ?? 1;
      cartItems[item['name']] = {
        'image': item['image'],
        'price': item['price'],
        'quantity': quantity,
        'flavor': selectedFlavor,
        'customizations': customizations,
      };
    });
  }//add to cart option

  void _updateQuantity(String itemName, int change) {
    setState(() {
      itemQuantity[itemName] = (itemQuantity[itemName] ?? 1) + change;
      if (itemQuantity[itemName]! < 1) {
        itemQuantity[itemName] = 1;
      }
    });
  }//quantity box

  int getCartItemCount() {
    return cartItems.values.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));
  }

  @override//appbar
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
          backgroundColor: const Color.fromARGB(230, 142, 173, 69),
          actions: <Widget>[
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  if (cartItems.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          getCartItemCount().toString(),
                          style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/cart', arguments: cartItems);//cart navigator
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: categories.keys.map((category) => Tab(text: category)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories.values.map((foodList) {
            return ListView.builder(
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                final foodItem = foodList[index];
                final itemName = foodItem['name'];
                final itemImage = foodItem['image'];
                final itemPrice = foodItem['price'];
                final flavors = foodItem['flavors'];
                final customizeOptions = foodItem['customizeOptions'];//details of food item that should be added to cart

                String selectedFlavor = selectedFlavors[itemName] ?? flavors.first;
                itemQuantity.putIfAbsent(itemName, () => 1);

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: ListTile(
                      leading: Image.asset(itemImage, width: 60, height: 60, fit: BoxFit.cover),
                      title: Text(itemName),
                      subtitle: Text('₹${itemPrice.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.red),
                            onPressed: () => _updateQuantity(itemName, -1),
                          ),
                          Text('${itemQuantity[itemName]}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.green),
                            onPressed: () => _updateQuantity(itemName, 1),
                          ),
                        ],
                      ),
                    ),
                    children: [
                      ...customizeOptions.map((customization) {
                        return CheckboxListTile(
                          title: Text(customization),
                          value: selectedCustomizations[itemName]?.contains(customization) ?? false,
                          onChanged: (bool? value) {
                            setState(() {
                              selectedCustomizations.putIfAbsent(itemName, () => []);
                              if (value == true) {
                                selectedCustomizations[itemName]!.add(customization);
                              } else {
                                selectedCustomizations[itemName]!.remove(customization);
                              }
                            });
                          },
                        );
                      }).toList(),
                      ElevatedButton(
                        onPressed: () {
                          _addToCart(foodItem, selectedFlavor, selectedCustomizations[itemName] ?? []);
                        },
                        child: const Text('Add to Cart'),//add to cart option
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cart', arguments: cartItems);
              },
              child: const Text('Proceed to Cart'),//navigate to cart
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:order/CartController.dart'; // Import the CartController

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Consumer<CCartController>(
        builder: (context, cart, child) {
          // Create a map to count the occurrences of each item
          Map<String, int> itemCounts = {};
          cart.items.forEach((item) {
            itemCounts[item] = (itemCounts[item] ?? 0) + 1;
          });

          return ListView.builder(
            itemCount: itemCounts.length,
            itemBuilder: (context, index) {
              String item = itemCounts.keys.elementAt(index);
              int count = itemCounts[item]!;

              return ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text('$item (x$count)'),
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.remove),
                    //   onPressed: () {
                    //     cart.removeFromCart(item);
                    //   },
                    // ),
                    Text(
                      '$count',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.add),
                    //   onPressed: () {
                    //     cart.addToCart(item);
                    //   },
                    // ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<CCartController>(context, listen: false).clearCart();
        },
        child: Icon(Icons.clear),
      ),
    );
  }
}

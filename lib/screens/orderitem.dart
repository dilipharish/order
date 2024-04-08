// import 'package:flutter/material.dart';
// import 'package:mysql1/mysql1.dart';
// import 'package:order/CartController.dart';
// import 'package:order/CartScreen.dart';
// import 'package:provider/provider.dart';

// class Product {
//   late int pid;
//   late String name;

//   Product({required this.pid, required this.name});
// }

// class Variant {
//   late int vid;
//   late int vpid;
//   late String name;
//   late double price;
//   late int stocksLeft;

//   Variant({
//     required this.vid,
//     required this.vpid,
//     required this.name,
//     required this.price,
//     required this.stocksLeft,
//   });
// }

// Future<List<Product>> fetchProducts(MySqlConnection conn) async {
//   var products = <Product>[];

//   var results = await conn.query('SELECT * FROM Product');

//   for (var row in results) {
//     var product = Product(pid: row[0], name: row[1]);
//     products.add(product);
//   }

//   return products;
// }

// Future<List<Variant>> fetchVariantsForProduct(
//     MySqlConnection conn, int productId) async {
//   var variants = <Variant>[];

//   var results =
//       await conn.query('SELECT * FROM variant WHERE vpid = ?', [productId]);

//   for (var row in results) {
//     var variant = Variant(
//       vid: row[0],
//       vpid: row[1],
//       name: row[2],
//       price: row[3],
//       stocksLeft: row[4],
//     );
//     variants.add(variant);
//   }

//   return variants;
// }

// class OrderItem extends StatefulWidget {
//   final int userId;

//   const OrderItem({Key? key, required this.userId}) : super(key: key);

//   @override
//   _OrderItemState createState() => _OrderItemState();
// }

// class _OrderItemState extends State<OrderItem> {
//   late CCartController _cartController;
//   late Map<int, int> _variantQuantities = {}; // Initialize directly

//   @override
//   void initState() {
//     super.initState();
//     _cartController = Provider.of<CCartController>(context, listen: false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Items for User ${widget.userId}'),
//         actions: [
//           Consumer<CCartController>(
//             builder: (context, cart, _) {
//               return Stack(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.shopping_cart),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => CartScreen()),
//                       );
//                     },
//                   ),
//                   if (cart.itemCount > 0)
//                     Positioned(
//                       right: 0,
//                       top: 0,
//                       child: Container(
//                         padding: EdgeInsets.all(2),
//                         decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         constraints: BoxConstraints(
//                           minWidth: 16,
//                           minHeight: 16,
//                         ),
//                         child: Text(
//                           cart.itemCount.toString(),
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder(
//         future: _cartController.connectToDatabase(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             return FutureBuilder<List<Product>>(
//               future: fetchProducts(_cartController.conn!),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Text('No products available');
//                 } else {
//                   return ListView.builder(
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           ExpansionTile(
//                             title: Padding(
//                               padding: EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text(
//                                 snapshot.data![index].name,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18.0,
//                                 ),
//                               ),
//                             ),
//                             tilePadding: EdgeInsets.only(
//                               top:
//                                   8.0, // Adjust the top padding to create a thick border
//                               left: 16.0,
//                               right: 16.0,
//                             ),
//                             children: [
//                               FutureBuilder<List<Variant>>(
//                                 future: fetchVariantsForProduct(
//                                     _cartController.conn!,
//                                     snapshot.data![index].pid),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.connectionState ==
//                                       ConnectionState.waiting) {
//                                     return Center(
//                                         child: CircularProgressIndicator());
//                                   } else if (snapshot.hasError) {
//                                     return Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Error: ${snapshot.error}',
//                                         style: TextStyle(
//                                           color: Colors.red,
//                                         ),
//                                       ),
//                                     );
//                                   } else if (!snapshot.hasData ||
//                                       snapshot.data!.isEmpty) {
//                                     return Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'No variants available',
//                                         style: TextStyle(
//                                           fontStyle: FontStyle.italic,
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     return Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.stretch,
//                                       children: snapshot.data!.map((variant) {
//                                         return Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: 8.0, vertical: 4.0),
//                                           child: Card(
//                                             child: ListTile(
//                                               title: Text(variant.name),
//                                               subtitle: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     'Price: ${variant.price}',
//                                                   ),
//                                                   Text(
//                                                     'Stocks Left: ${variant.stocksLeft}',
//                                                   ),
//                                                   TextFormField(
//                                                     keyboardType:
//                                                         TextInputType.number,
//                                                     decoration: InputDecoration(
//                                                       labelText: 'Quantity',
//                                                     ),
//                                                     onChanged: (value) {
//                                                       // Validate if the entered value is a valid integer
//                                                       if (value.isNotEmpty &&
//                                                           int.tryParse(value) !=
//                                                               null) {
//                                                         // Update the variant quantity in the map
//                                                         _variantQuantities[
//                                                                 variant.vid] =
//                                                             int.parse(value);
//                                                       } else {
//                                                         // Clear the value if it's not a valid integer
//                                                         _variantQuantities
//                                                             .remove(
//                                                                 variant.vid);
//                                                       }
//                                                     },
//                                                   ),
//                                                 ],
//                                               ),
//                                               trailing: ElevatedButton(
//                                                 onPressed: () {
//                                                   // Add the variant with specified quantity to cart
//                                                   if (_variantQuantities
//                                                       .containsKey(
//                                                           variant.vid)) {
//                                                     for (int i = 0;
//                                                         i <
//                                                             _variantQuantities[
//                                                                 variant.vid]!;
//                                                         i++) {
//                                                       _cartController.addToCart(
//                                                           variant.name);
//                                                     }
//                                                   }
//                                                 },
//                                                 child: Text('Add to Cart'),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       }).toList(),
//                                     );
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                               height:
//                                   8.0), // Add spacing between ExpansionTiles
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:order/CartController.dart';
import 'package:order/CartScreen.dart';
import 'package:provider/provider.dart';

class Product {
  late int pid;
  late String name;

  Product({required this.pid, required this.name});
}

class Variant {
  late int vid;
  late int vpid;
  late String name;
  late double price;
  late int stocksLeft;

  Variant({
    required this.vid,
    required this.vpid,
    required this.name,
    required this.price,
    required this.stocksLeft,
  });
}

Future<List<Product>> fetchProducts(MySqlConnection conn) async {
  var products = <Product>[];

  var results = await conn.query('SELECT * FROM Product');

  for (var row in results) {
    var product = Product(pid: row[0], name: row[1]);
    products.add(product);
  }

  return products;
}

Future<List<Variant>> fetchVariantsForProduct(
    MySqlConnection conn, int productId) async {
  var variants = <Variant>[];

  var results =
      await conn.query('SELECT * FROM variant WHERE vpid = ?', [productId]);

  for (var row in results) {
    var variant = Variant(
      vid: row[0],
      vpid: row[1],
      name: row[2],
      price: row[3],
      stocksLeft: row[4],
    );
    variants.add(variant);
  }

  return variants;
}

class OrderItem extends StatefulWidget {
  final int userId;

  const OrderItem({Key? key, required this.userId}) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  late CCartController _cartController;
  late Map<int, int> _variantQuantities = {};
  late int oid = 0; // Initialize directly

  @override
  void initState() {
    super.initState();
    _cartController = Provider.of<CCartController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Items for User  ${widget.userId}'),
        actions: [
          Consumer<CCartController>(
            builder: (context, cart, _) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          cart.itemCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _cartController.connectToDatabase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return FutureBuilder<List<Product>>(
                      future: fetchProducts(_cartController.conn!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('No products available');
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ExpansionTile(
                                    backgroundColor:
                                        Color.fromARGB(255, 236, 235, 231),
                                    title: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        snapshot.data![index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    tilePadding: EdgeInsets.only(
                                      top:
                                          8.0, // Adjust the top padding to create a thick border
                                      left: 16.0,
                                      right: 16.0,
                                    ),
                                    children: [
                                      FutureBuilder<List<Variant>>(
                                        future: fetchVariantsForProduct(
                                            _cartController.conn!,
                                            snapshot.data![index].pid),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Error: ${snapshot.error}',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            );
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'No variants available',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children:
                                                  snapshot.data!.map((variant) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0),
                                                  child: Card(
                                                    child: ListTile(
                                                      title: Text(variant.name),
                                                      subtitle: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Price: ${variant.price}',
                                                          ),
                                                          TextFormField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Quantity',
                                                            ),
                                                            onChanged: (value) {
                                                              // Validate if the entered value is a valid integer
                                                              if (value
                                                                      .isNotEmpty &&
                                                                  int.tryParse(
                                                                          value) !=
                                                                      null) {
                                                                // Update the variant quantity in the map
                                                                _variantQuantities[
                                                                        variant
                                                                            .vid] =
                                                                    int.parse(
                                                                        value);
                                                              } else {
                                                                // Clear the value if it's not a valid integer
                                                                _variantQuantities
                                                                    .remove(
                                                                        variant
                                                                            .vid);
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      trailing: ElevatedButton(
                                                        onPressed: () {
                                                          // Add the variant with specified quantity to cart
                                                          if (_variantQuantities
                                                              .containsKey(
                                                                  variant
                                                                      .vid)) {
                                                            for (int i = 0;
                                                                i <
                                                                    _variantQuantities[
                                                                        variant
                                                                            .vid]!;
                                                                i++) {
                                                              _cartController
                                                                  .addToCart(
                                                                      variant
                                                                          .name);
                                                            }
                                                          }
                                                        },
                                                        child:
                                                            Text('Add to Cart'),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          8.0), // Add spacing between ExpansionTiles
                                ],
                              );
                            },
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () async {
                  // Insert data into the "orderitem" table
                  await _insertOrderItems();

                  // Clear the cart after successful submission
                  _cartController.clearCart();

                  // Show success message in a dialog box
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Order Submitted'),
                        content: Text(
                            'Your order has been successfully submitted. For Billing Details ,Please look at  order id:${oid} in History screen, Thank You'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  color: Colors.amber,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 198, 79, 241),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_checkout_rounded,
                            color: Colors.white),
                        SizedBox(width: 8.0),
                        Text(
                          'Submit Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Icon(Icons.delivery_dining_sharp, color: Colors.white),
                      ],
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

  Future<void> _insertOrderItems() async {
    try {
      // Insert data into the "orders" table and get the inserted oid
      var result = await _cartController.conn!.query(
        'INSERT INTO orders (ouid) VALUES (?)',
        [widget.userId],
      );
      // var oid = result.insertId;
      setState(() {
        oid = result.insertId!;
      });

      // Insert data into the "orderitem" table using the obtained oid and variant quantities
      for (var entry in _variantQuantities.entries) {
        await _cartController.conn!.query(
          'INSERT INTO orderitem (oioid, oivid, quantity) VALUES (?, ?, ?)',
          [oid, entry.key, entry.value],
        );
      }
    } catch (e) {
      print('Error inserting order items: $e');
    }
  }
}

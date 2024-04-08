// import 'package:flutter/material.dart';
// import 'package:mysql1/mysql1.dart';
// import 'package:get/get.dart'; // Import GetX for state management
// import 'package:order/constants.dart';
// import 'cart_controller.dart'; // Import the CartController class

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
//   CartController? _controller; // Make _controller nullable

//   @override
//   void initState() {
//     super.initState();
//     _controller = Get.find<CartController>();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_controller == null) {
//       // Handle the case where _controller is not yet initialized
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Order Items for User ${widget.userId}'),
//         ),
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     } else {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Order Items for User ${widget.userId}'),
//           actions: [
//             Stack(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.shopping_cart),
//                   onPressed: () {
//                     Get.to(CartScreen());
//                   },
//                 ),
//                 if (_controller!.cartItems.isNotEmpty)
//                   Positioned(
//                     right: 5,
//                     top: 5,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.red,
//                       radius: 10,
//                       child: Text(
//                         '${_controller!.cartItems.length}',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//         body: FutureBuilder<List<Product>>(
//           future: fetchProducts(_controller!.conn),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Text('No products available');
//             } else {
//               return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   return ExpansionTile(
//                     title: Text(snapshot.data![index].name),
//                     children: [
//                       FutureBuilder<List<Variant>>(
//                         future: fetchVariantsForProduct(
//                             _controller!.conn, snapshot.data![index].pid),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return Center(child: CircularProgressIndicator());
//                           } else if (snapshot.hasError) {
//                             return Text('Error: ${snapshot.error}');
//                           } else if (!snapshot.hasData ||
//                               snapshot.data!.isEmpty) {
//                             return Text('No variants available');
//                           } else {
//                             return Column(
//                               children: snapshot.data!.map((variant) {
//                                 return ListTile(
//                                   title: Text(variant.name),
//                                   subtitle: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text('Price: ${variant.price}'),
//                                       Text(
//                                           'Stocks Left: ${variant.stocksLeft}'),
//                                     ],
//                                   ),
//                                   trailing: ElevatedButton(
//                                     onPressed: () {
//                                       _controller!.addToCart(variant);
//                                     },
//                                     child: Text('Add to Cart'),
//                                   ),
//                                 );
//                               }).toList(),
//                             );
//                           }
//                         },
//                       ),
//                       Divider(), // Add a divider after each product
//                     ],
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       );
//     }
//   }
// }
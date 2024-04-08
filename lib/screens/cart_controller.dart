// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:order/constants.dart';
// import 'package:mysql1/mysql1.dart';
// import 'package:order/screens/orderitem.dart';

// class CartController extends GetxController {
//   RxList<Variant> cartItems = <Variant>[].obs;
//   RxInt itemCount = 0.obs;

//   late MySqlConnection conn;

//   @override
//   void onInit() {
//     super.onInit();
//     connectToDatabase();
//   }

//   Future<void> connectToDatabase() async {
//     try {
//       conn = await MySqlConnection.connect(settings);
//     } catch (e) {
//       print('Error connecting to database: $e');
//     }
//   }

//   bool get isConnected => conn != null;

//   void addToCart(Variant variant) {
//     cartItems.add(variant);
//     itemCount++;
//   }

//   void removeFromCart(Variant variant) {
//     cartItems.remove(variant);
//     itemCount--;
//   }

//   // Optionally, you can also override onClose() to close the database connection when the controller is disposed
//   @override
//   void onClose() {
//     conn.close();
//     super.onClose();
//   }
// }

// class CartScreen extends StatefulWidget {
//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   late CartController _cartController;

//   @override
//   void initState() {
//     super.initState();
//     _cartController = Get.find();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cart'),
//         actions: [
//           CartIcon(), // Display the custom cart icon widget
//         ],
//       ),
//       body: Obx(
//         () => ListView.builder(
//           itemCount: _cartController.cartItems.length,
//           itemBuilder: (context, index) {
//             final variant = _cartController.cartItems[index];
//             return ListTile(
//               title: Text(variant.name),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Price: ${variant.price}'),
//                   Text('Stocks Left: ${variant.stocksLeft}'),
//                 ],
//               ),
//               trailing: IconButton(
//                 icon: Icon(Icons.remove_circle),
//                 onPressed: () {
//                   _cartController.removeFromCart(variant);
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Container(
//           height: 50,
//           child: Center(
//             child: Obx(() =>
//                 Text('Items in Cart: ${_cartController.itemCount.value}')),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CartIcon extends StatefulWidget {
//   @override
//   _CartIconState createState() => _CartIconState();
// }

// class _CartIconState extends State<CartIcon> {
//   late CartController _cartController;

//   @override
//   void initState() {
//     super.initState();
//     _cartController = Get.find();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => IconButton(
//           icon: Stack(
//             children: [
//               Icon(Icons.shopping_cart),
//               if (_cartController.itemCount.value > 0)
//                 Positioned(
//                   right: 0,
//                   top: 0,
//                   child: Container(
//                     padding: EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     constraints: BoxConstraints(
//                       minWidth: 16,
//                       minHeight: 16,
//                     ),
//                     child: Text(
//                       _cartController.itemCount.value.toString(),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           onPressed: () {
//             // Navigate to the cart screen when the cart icon is tapped
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => CartScreen()),
//             );
//           },
//         ));
//   }
// }

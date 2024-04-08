// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mysql1/mysql1.dart';
// import 'package:order/constants.dart';
// import 'package:order/screens/cart_controller.dart'; // Import the CartController class
// import 'orderitem.dart';

// class CartScreen extends StatefulWidget {
//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   late int localItemCount;
//   late final RxInt itemCount;

//   @override
//   void initState() {
//     super.initState();
//     localItemCount = CartController.to.itemCount.value;
//     itemCount = CartController.to.itemCount;
//   }

//   @override
//   void dispose() {
//     // Dispose of the subscription manually
//     // Remove the listener to avoid memory leaks
//     itemCount.removeListener(updateItemCount);
//     super.dispose();
//   }

//   // Listener function to update localItemCount
//   void updateItemCount() {
//     setState(() {
//       localItemCount = CartController.to.itemCount.value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Add the listener to itemCount when the widget is built
//     itemCount.addListener(updateItemCount);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cart'),
//       ),
//       body: GetBuilder<CartController>(
//         builder: (controller) => ListView.builder(
//           itemCount: controller.cartItems.length,
//           itemBuilder: (context, index) {
//             final variant = controller.cartItems[index];
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
//                   controller.removeFromCart(variant);
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
//             child: Text('Items in Cart: $localItemCount'),
//           ),
//         ),
//       ),
//     );
//   }
// }

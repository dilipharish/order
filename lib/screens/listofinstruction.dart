import 'package:flutter/material.dart';

class ListOfInstructions extends StatefulWidget {
  final int userId;

  const ListOfInstructions({Key? key, required this.userId}) : super(key: key);

  @override
  _ListOfInstructionsState createState() => _ListOfInstructionsState();
}

class _ListOfInstructionsState extends State<ListOfInstructions> {
  @override
  Widget build(BuildContext context) {
    // Implement your UI for the ListOfInstructions widget here
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "In Shopping Screen ,once you enter the Quantity ,Make sure You click on Add to Cart button,Else It fails to register that item in Cart.                   ------------------------------ In History Screen scroll down if you are unable to see the order id pdf.   -------------------------------Users Can Get Billing details in Respective Order Id PDF in History Screen.                                                    ------------------------------Once User clicks on Submit Order button then that Respective Order is submited and Cart Functionality is Reset.                                                  -------------------------------To Log Out click Drawer at Left Top Corner, click on Logout Option",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          // Add more UI components as needed
        ],
      ),
    );
  }
}

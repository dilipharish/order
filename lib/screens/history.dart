import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:mysql1/mysql1.dart';
import 'package:order/constants.dart';

class HistoryScreen extends StatefulWidget {
  final int userId;

  const HistoryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<Map<String, dynamic>> orderItems = [];

  @override
  void initState() {
    super.initState();
    fetchOrderItems();
  }

  Future<void> fetchOrderItems() async {
    try {
      final MySqlConnection conn = await MySqlConnection.connect(settings);

      var results = await conn.query(
        '''
      SELECT o.*, u.* FROM orders o
      INNER JOIN user u ON o.ouid = u.uid
      WHERE o.ouid = ?
      ''',
        [widget.userId],
      );

      List<Map<String, dynamic>> fetchedOrderItems = [];

      for (var row in results) {
        fetchedOrderItems.add(row.fields);
      }

      setState(() {
        orderItems = fetchedOrderItems;
      });

      print('Fetched order items: $orderItems'); // Print fetched items

      await conn.close();
    } catch (e) {
      // Handle error...
      print('Error fetching order items: $e');
    }
  }

  Future<void> _generateAndSendPDF(int oid) async {
    PdfDocument document = PdfDocument();
    document.pageSettings.size = PdfPageSize.a4;
    document.pageSettings.orientation = PdfPageOrientation.portrait;

    // Create a PDF font for the heading
    PdfFont headingFont = PdfStandardFont(PdfFontFamily.helvetica, 18);

    // Create a PDF font for the content
    PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);

    // Extract data from the database
    try {
      final MySqlConnection conn = await MySqlConnection.connect(settings);

      var results = await conn.query(
        '''
  SELECT o.*, u.*, p.name AS product_name, v.name AS variant_name, v.price AS variant_price, oi.quantity
  FROM orders o
  INNER JOIN user u ON o.ouid = u.uid
  INNER JOIN orderitem oi ON o.oid = oi.oioid
  INNER JOIN variant v ON oi.oivid = v.vid
  INNER JOIN product p ON v.vpid = p.pid
  WHERE o.oid = ?
  ''',
        [oid],
      );

      if (results.isNotEmpty) {
        var firstRow = results.first;
        int orderId = firstRow['oid'];
        DateTime orderDate = firstRow['order_date'];
        int userId = firstRow['uid'];
        String userName = firstRow['name'];
        String userEmail = firstRow['email'];
        String userAddress = firstRow['address'];
        String userPhoneNumber = firstRow['phone_number'];

        // Draw user details only once
        PdfPage page = document.pages.add();
        page.graphics.drawString(
          '-------------- National Company --------------',
          headingFont,
          bounds: Rect.fromLTWH(50, 20, 400, 30),
        );
        page.graphics.drawString(
          'Order ID: $orderId',
          font,
          bounds: Rect.fromLTWH(50, 70, 200, 20),
        );
        page.graphics.drawString(
          'Order Date: $orderDate',
          font,
          bounds: Rect.fromLTWH(50, 90, 200, 20),
        );
        page.graphics.drawString(
          'User ID: $userId',
          font,
          bounds: Rect.fromLTWH(50, 110, 200, 20),
        );
        page.graphics.drawString(
          'Name: $userName',
          font,
          bounds: Rect.fromLTWH(50, 130, 200, 20),
        );
        page.graphics.drawString(
          'Email: $userEmail',
          font,
          bounds: Rect.fromLTWH(50, 150, 200, 20),
        );
        page.graphics.drawString(
          'Address: $userAddress',
          font,
          bounds: Rect.fromLTWH(50, 170, 400, 20),
        );
        page.graphics.drawString(
          'Phone Number: $userPhoneNumber',
          font,
          bounds: Rect.fromLTWH(50, 190, 200, 20),
        );
        page.graphics.drawString(
          '----------------------------------------------------------------------------------------------------',
          font,
          bounds: Rect.fromLTWH(50, 200, 450, 20),
        );
        page.graphics.drawString(
          '                                                  Billing                                                  ',
          font,
          bounds: Rect.fromLTWH(50, 210, 450, 20),
        );
        page.graphics.drawString(
          '----------------------------------------------------------------------------------------------------',
          font,
          bounds: Rect.fromLTWH(50, 220, 450, 20),
        );

        // Iterate over order items and draw details
        int yOffset = 240;
        double totalCostSum = 0; // Variable to store the total cost sum
        int itemsPerPage = 5; // Items to display per page
        int itemCounter = 0; // Counter for items on the current page

        for (var row in results) {
          // Extract product and variant details
          String productName = row['product_name'];
          String variantName = row['variant_name'];
          double variantPrice = row['variant_price'];
          int quantity = row['quantity'];

          // Calculate total cost
          double totalCost = variantPrice * quantity;
          totalCostSum += totalCost; // Add current item's total cost to sum

          // Draw data onto the PDF page
          page.graphics.drawString(
            'Product: $productName - $variantName',
            font,
            bounds: Rect.fromLTWH(50, yOffset.toDouble(), 400, 20),
          );
          page.graphics.drawString(
            'Price: $variantPrice',
            font,
            bounds: Rect.fromLTWH(50, yOffset + 20, 250, 20),
          );
          page.graphics.drawString(
            'Quantity: $quantity',
            font,
            bounds: Rect.fromLTWH(50, yOffset + 40, 250, 20),
          );
          page.graphics.drawString(
            'Total Cost: $totalCost',
            font,
            bounds: Rect.fromLTWH(50, yOffset + 60, 250, 20),
          );
          page.graphics.drawString(
            '---------------------------------------------------------------------------------------------------------',
            font,
            bounds: Rect.fromLTWH(50, yOffset + 80, 400, 20),
          );

          yOffset += 100; // Adjust Y offset for next item
          itemCounter++; // Increment item counter

          // Check if we need to add a new page or reset item counter
          if (itemCounter >= itemsPerPage) {
            page = document.pages.add();
            yOffset = 50; // Reset Y offset for new page
            itemCounter = 0; // Reset item counter
          }
        }

        // Draw total cost sum at the end
        page.graphics.drawString(
          'Total Cost Sum: $totalCostSum',
          font,
          bounds: Rect.fromLTWH(50, yOffset.toDouble(), 200, 20),
        );

        // Draw a line
        page.graphics.drawLine(
          PdfPen(PdfColor(0, 0, 0), width: 1),
          Offset(50, yOffset + 30),
          Offset(550, yOffset + 30),
        );
      }

      await conn.close();
    } catch (e) {
      // Handle error...
      print('Error fetching data: $e');
    }

    // Save the PDF document to a file
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/OrderItemReport_$oid.pdf';
    File file = File(filePath);
    await file.writeAsBytes(await document.save());

    // Open the saved PDF file
    OpenFile.open(filePath);

    // Dispose the PDF document
    document.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User ID : ${widget.userId}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // Generate ElevatedButton for each oid
            Column(
              children: orderItems.map((item) {
                int oid = item['oid'];
                return ElevatedButton(
                  onPressed: () {
                    _generateAndSendPDF(oid);
                  },
                  child: Text('Generate PDF Bill of order id $oid'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

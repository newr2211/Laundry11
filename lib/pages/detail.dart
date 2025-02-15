import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Laundry/pages/booking.dart';
import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  final List<String> selectedServices;
  final List<String> selectedPrices;

  const Detail({
    super.key,
    required this.selectedServices,
    required this.selectedPrices,
  });

  // คำนวณราคาทั้งหมด
  int calculateTotalPrice() {
    int totalPrice = 0;
    for (var price in selectedPrices) {
      totalPrice += int.tryParse(price.replaceAll('฿', '').trim()) ?? 0;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "รายละเอียดการจอง",
          style:
              TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[50],
        iconTheme: IconThemeData(color: Colors.blue[700]),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.blue[50]),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "บริการที่เลือก",
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: selectedServices.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        selectedServices[index],
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                      trailing: Text(
                        selectedPrices[index],
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(color: Colors.blueGrey, thickness: 2.0),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "รวมทั้งหมด",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                Text(
                  "$totalPrice฿",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Booking(
                      service: selectedServices.join(", "),
                      price: "$totalPrice฿",
                      selectedServices: selectedServices,
                      selectedPrices: selectedPrices,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              ),
              child: Center(
                child: Text(
                  "เลือกเวลาการจอง",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

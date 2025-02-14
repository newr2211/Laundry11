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

  // ฟังก์ชันเพื่อบันทึกข้อมูลลง Firebase
  Future<void> saveBookingToFirebase(int totalPrice) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, dynamic> bookingData = {
          'userId': user.uid,
          'service': selectedServices,
          'prices': selectedPrices,
          'totalPrice': totalPrice,
          'bookingDate': Timestamp.now(),
        };

        await FirebaseFirestore.instance
            .collection('Bookings')
            .add(bookingData);
        print("Booking saved to Firebase!");
      }
    } catch (e) {
      print("Error saving booking to Firebase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "รายละเอียดการจอง",
          style: TextStyle(color: Colors.yellow),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.yellow),
      ),
      body: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "บริการที่เลือก",
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: selectedServices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      selectedServices[index],
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    trailing: Text(
                      selectedPrices[index],
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            Divider(color: Colors.white, thickness: 2.0),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "รวมทั้งหมด",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "$totalPrice฿",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
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
              child: Center(child: Text("เลือกเวลาการจอง")),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

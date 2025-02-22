import 'package:Laundry/services/serviceProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // นำเข้า Provider
import 'booking.dart'; // นำเข้า Booking page
import 'home.dart'; // นำเข้า Home page
// นำเข้า ServiceProvider

class Detail extends StatelessWidget {
  final List<Map<String, dynamic>> selectedServices;
  final List<int> selectedPrices;
  final Map serviceQuantities;

  // รับข้อมูลจาก constructor
  Detail({
    required this.selectedServices,
    required this.selectedPrices,
    required this.serviceQuantities,
  });

  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูลจาก ServiceProvider
    final provider = Provider.of<ServiceProvider>(context);

    // คำนวณราคาทั้งหมดจากราคาของบริการ
    int totalPrice = selectedPrices.fold(0, (prev, amount) => prev + amount);

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue[700]),
          onPressed: () {
            // นำผู้ใช้กลับไปยังหน้า Home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (Route<dynamic> route) => false,
            );
          },
        ),
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
                itemCount: selectedServices.length, // จำนวนบริการที่เลือก
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        selectedServices[index]['service'], // ชื่อบริการ
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                      trailing: Text(
                        '${selectedPrices[index]}฿', // ราคาของบริการ
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
                  "$totalPrice฿", // แสดงราคาทั้งหมด
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
                // นำข้อมูลที่เลือกไปยังหน้า Booking
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Booking(
                      selectedServices: selectedServices,
                      totalPrice: totalPrice,
                      selectedPrices: selectedPrices,
                      service: '',
                      price: '',
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

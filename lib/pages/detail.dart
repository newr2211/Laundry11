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

  @override
  Widget build(BuildContext context) {
    int totalPrice = 0;
    for (var price in selectedPrices) {
      totalPrice += int.tryParse(price.replaceAll('฿', '').trim()) ?? 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "รายละเอียดการจอง",
          style: TextStyle(color: Colors.yellow), // เปลี่ยนสีเป็นเหลือง
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
            color: Colors.yellow), // เปลี่ยนสีไอคอนย้อนกลับเป็นเหลือง
      ),
      body: Container(
        color: Colors.blue, // เปลี่ยนพื้นหลังเป็นสีฟ้า
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "บริการที่เลือก",
              style: TextStyle(
                color: Colors.yellow, // เปลี่ยนสีเป็นเหลือง
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
                      price: selectedPrices.join(", "),
                      selectedServices: selectedServices,
                      selectedPrices: [],
                    ),
                  ),
                );
              },
              child: Center(child: Text("เลือกเวลาการจอง")),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingHistory extends StatelessWidget {
  const BookingHistory({Key? key}) : super(key: key);

  void _showBookingDetails(BuildContext context, Map<String, dynamic> booking) {
    List<Map<String, dynamic>> services = (booking['Services'] as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("รายละเอียดการจอง"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📅 วันที่จอง: ${booking['Date'] ?? 'ไม่ระบุ'}"),
                Text("⏰ เวลา: ${booking['Time'] ?? 'ไม่ระบุ'}"),
                const SizedBox(height: 10),
                const Text("📝 รายการบริการที่เลือก:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(services.length, (index) {
                    var item = services[index];
                    String serviceName = item['service'] ?? 'ไม่ระบุ';
                    int quantity = item['quantity'] ?? 1;
                    int pricePerUnit = item['price'] ?? 0;
                    int totalPrice = quantity * pricePerUnit;

                    return Text("• $serviceName ($quantity ชิ้น) - ฿$totalPrice");
                  }),
                ),
                const SizedBox(height: 10),
                Text("📍 ที่อยู่จัดส่ง: ${booking['DeliveryAddress'] ?? 'ไม่ระบุ'}"),
                const SizedBox(height: 10),
                Text(
                  "📌 สถานะ: ${booking['Status'] ?? 'รอดำเนินการ'}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("ปิด", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String userEmail = FirebaseAuth.instance.currentUser?.email ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("ประวัติการจอง"),
        backgroundColor: Colors.blue[700], // สี AppBar
      ),
      backgroundColor: Colors.blue[50], // สีพื้นหลังหน้าจอ
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Bookings')
            .where('Email', isEqualTo: userEmail) // ใช้ email แทน uid
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("ไม่มีประวัติการจอง"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final booking = snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: (){
                  _showBookingDetails(context, booking);
                },
                child: Card(
                  color: Colors.white, // สีการ์ด
                  shadowColor: Colors.blue[700], // เงาของการ์ด
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      "วันที่จอง: ${booking['Date']}",
                      style: TextStyle(color: Colors.blue[700]), // เปลี่ยนสีข้อความ
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ยอดรวม: ฿${booking['TotalPrice']}", style: TextStyle(color: Colors.blue[900])),
                        Text("เวลา: ${booking['Time']}", style: TextStyle(color: Colors.blueGrey[800])),
                        Text("ที่อยู่จัดส่ง: ${booking['DeliveryAddress']}"),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

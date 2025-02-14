import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingHistory extends StatelessWidget {
  const BookingHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("การจองของฉัน",
              style: TextStyle(color: Colors.yellow)),
          backgroundColor: Colors.blue,
        ),
        body: const Center(
          child: Text(
            "กรุณาเข้าสู่ระบบก่อน",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:
            const Text("ประวัติการจอง", style: TextStyle(color: Colors.yellow)),
        backgroundColor: Colors.blue,
      ),
      body: _buildBookingHistory(context, user),
    );
  }

  Widget _buildBookingHistory(BuildContext context, User user) {
    return Container(
      color: Colors.blue,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Bookings')
            .where('Email', isEqualTo: user.email)
            .orderBy('Date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("ไม่มีประวัติการจอง",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            );
          }

          var bookings = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              var booking = bookings[index];

              // ดึงข้อมูลรายการบริการที่เลือก
              List<String> services = (booking['SelectedServices'] != null)
                  ? List<String>.from(booking['SelectedServices'])
                  : [booking['Service'] ?? 'ไม่ระบุ'];

              // ดึงข้อมูลราคาทั้งหมด
              List<String> prices = (booking['SelectedPrices'] != null)
                  ? List<String>.from(booking['SelectedPrices'])
                  : [booking['Price'] ?? 'ไม่ระบุ'];

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    "วันที่จอง: ${booking['Date']}", // ✅ แสดงเฉพาะบริการแรก
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "ราคา: ${prices.first}"), // ✅ แสดงเฉพาะราคาของบริการแรก
                      Text("เวลา: ${booking['Time']}"),
                      if (services.length >
                          1) // ✅ ถ้ามีบริการมากกว่า 1 ให้แสดง "...ดูเพิ่มเติม"
                        const Text("...ดูเพิ่มเติม",
                            style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                  trailing: const Icon(Icons.info_outline, color: Colors.blue),
                  onTap: () {
                    _showBookingDetails(context, booking, services, prices);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showBookingDetails(BuildContext context, Map<String, dynamic> booking,
      List<String> services, List<String> prices) {
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
                    return Text("• ${services[index]} - ${prices[index]}");
                  }),
                ),
                const SizedBox(height: 10),
                Text("📌 สถานะ: ${booking['Status'] ?? 'รอดำเนินการ'}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดป๊อปอัพ
              },
              child: const Text("ปิด", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

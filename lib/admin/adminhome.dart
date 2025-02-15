import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Laundry/pages/login.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String userName = "Admin";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
      return;
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          userName = userDoc['Name'] ?? "Admin";
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
    } catch (e) {
      print('Error during sign out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : Padding(
              padding:
                  const EdgeInsets.only(top: 70.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 48.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: logOut,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          child: Center(
                            child:
                                Icon(Icons.logout, color: Colors.red, size: 40),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Divider(color: Colors.blue, thickness: 2.0),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      "ข้อมูลการจองลูกค้า",
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  _buildBookingList(context),
                ],
              ),
            ),
    );
  }

  Widget _buildBookingList(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Bookings')
            .orderBy('Date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("ไม่มีคำสั่งจอง",
                  style: TextStyle(color: Colors.blue, fontSize: 18)),
            );
          }

          var bookings = snapshot.data!.docs
              .map((doc) =>
                  {'id': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList();

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              var booking = bookings[index];

              List<String> services = (booking['SelectedServices'] != null)
                  ? List<String>.from(booking['SelectedServices'])
                  : [booking['Service'] ?? 'ไม่ระบุ'];

              List<String> prices = (booking['SelectedPrices'] != null)
                  ? List<String>.from(booking['SelectedPrices'])
                  : [booking['Price'] ?? 'ไม่ระบุ'];

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    "${booking['Username']} - ${booking['Date']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ราคา: ${prices.first}"),
                      Text("เวลา: ${booking['Time']}"),
                      Text("สถานะ: ${booking['Status'] ?? 'รอดำเนินการ'}"),
                      if (services.length > 1)
                        const Text("...ดูเพิ่มเติม",
                            style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      _updateBookingStatus(booking['id'], value);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: "กำลังดำเนินการ",
                          child: Text("กำลังดำเนินการ")),
                      const PopupMenuItem(
                          value: "เสร็จสิ้น", child: Text("เสร็จสิ้น")),
                      const PopupMenuItem(
                          value: "ยกเลิก", child: Text("ยกเลิก")),
                    ],
                    icon: const Icon(Icons.more_vert, color: Colors.blue),
                  ),
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

  void _updateBookingStatus(String bookingId, String status) {
    FirebaseFirestore.instance.collection('Bookings').doc(bookingId).update({
      'Status': status,
    });
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
                Text("📧 ผู้ใช้: ${booking['Email'] ?? 'ไม่ระบุ'}"),
                const SizedBox(height: 10),
                const Text("📝 รายการบริการที่เลือก:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
                Navigator.of(context).pop();
              },
              child: const Text("ปิด", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

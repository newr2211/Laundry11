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
        var data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          userName = data['Name']?.toString() ?? "Admin";
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

              String username = booking['Username']?.toString() ?? 'ไม่ระบุ';
              String email = booking['Email']?.toString() ?? 'ไม่ระบุ';
              String date = booking['Date']?.toString() ?? 'ไม่ระบุ';
              String time = booking['Time']?.toString() ?? 'ไม่ระบุ';
              String status = booking['Status']?.toString() ?? 'รอดำเนินการ';
              String address = booking['DeliveryAddress']?.toString() ?? 'ไม่ระบุ';

              return Card(
                margin:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: Colors.white,
                child: ListTile(
                  title: Text("$username - $date",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📅 วันที่จอง: $date"),
                      Text("⏰ เวลา: $time"),
                      Text("📧 ผู้ใช้: $email"),
                      Text("📌 สถานะ: $status"),
                      Text("🏠 ที่อยู่การจัดส่ง: $address"),
                    ],
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

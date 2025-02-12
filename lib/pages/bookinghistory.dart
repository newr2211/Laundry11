import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingHistory extends StatefulWidget {
  @override
  _BookingHistoryState createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  String? userEmail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserEmail();
  }

  // ฟังก์ชันดึงอีเมลของผู้ใช้ที่ล็อกอิน
  void getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ประวัติการจองคิว"),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userEmail == null
              ? Center(child: Text("กรุณาล็อกอินก่อน"))
              : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Bookings")
                      .where("Email", isEqualTo: userEmail)
                      .orderBy("Date", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("ไม่มีประวัติการจอง"));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var booking = snapshot.data!.docs[index];
                        List<dynamic> services = booking["Service"];
                        List<dynamic> prices = booking["Price"];
                        String date = booking["Date"];
                        String time = booking["Time"];

                        return Card(
                          margin: EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 5,
                          color: Colors.white,
                          child: ListTile(
                            leading: Icon(Icons.event,
                                color: Colors.orange, size: 40),
                            title: Text(
                              "บริการที่เลือก",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("วันที่: $date"),
                                Text("เวลา: $time"),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(services.length, (i) {
                                    return Text(
                                      "${services[i]} - ${prices[i]}",
                                      style: TextStyle(fontSize: 16.0),
                                    );
                                  }),
                                ),
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

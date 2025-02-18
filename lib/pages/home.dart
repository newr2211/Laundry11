import 'package:Laundry/pages/bookinghistory.dart';
import 'package:Laundry/pages/detail.dart';
import 'package:Laundry/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:Laundry/pages/booking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Laundry/pages/service1.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = "User";
  bool isLoading = true;
  int _currentIndex = 0;

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
          userName = userDoc['Name'] ?? "User";
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

  void onTabTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Detail(selectedServices: [], selectedPrices: []),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookingHistory()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ยินดีให้บริการ",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w500)),
                          Text(userName,
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: Colors.red, size: 30),
                        onPressed: logOut,
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Divider(color: Colors.grey, thickness: 1.5),
                  SizedBox(height: 10.0),
                  Text("บริการ",
                      style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Service1(),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('ซักเสื้อผ้าทั่วไป',
                            style: TextStyle(fontSize: 18)),
                        subtitle: Text('300฿', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                  ...[
                    {'service': 'ซักผ้าปูที่นอน,ฝูก', 'price': '1000฿'},
                    {'service': 'ซักชุดนักเรียน,สูท', 'price': '400฿'},
                    {'service': 'ซักผ้าม่าน', 'price': '500฿'},
                    {'service': 'ซักรองเท้า', 'price': '150฿'},
                    {'service': 'ซักรองเท้าหนัง', 'price': '500฿'}
                  ].map((item) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detail(
                                selectedServices: [item['service']!],
                                selectedPrices: [item['price']!],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          child: ListTile(
                            title: Text(item['service']!,
                                style: TextStyle(fontSize: 18)),
                            subtitle: Text(item['price']!,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      )),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'รายการที่เลือก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'ประวัติการจอง',
          ),
        ],
      ),
    );
  }
}

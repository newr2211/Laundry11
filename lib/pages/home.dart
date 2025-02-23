import 'package:Laundry/pages/bookinghistory.dart';
import 'package:Laundry/pages/detail.dart';
import 'package:Laundry/pages/editprofile.dart';
import 'package:Laundry/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:Laundry/pages/service1.dart';
import 'package:Laundry/pages/service2.dart';
import 'package:Laundry/pages/service3.dart';
import 'package:Laundry/pages/service4.dart';
import 'package:Laundry/pages/service5.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookingHistory()),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartScreen()),
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
                          Row(
                            children: [
                              Text(userName,
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfile(),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit))
                            ],
                          ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Service1(),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: 150,
                          color: Colors.blue[700],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/111.png", // รูปภาพที่เพิ่ม
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(height: 10), // เพิ่มระยะห่าง
                                Text('ซัก-ผับ', style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 30.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Service2(),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: 150,
                          color: Colors.pinkAccent,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/44.png", // รูปภาพที่เพิ่ม
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(height: 10), // เพิ่มระยะห่าง
                                Text('ซักรองเท้า',
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Service3(),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: 150,
                          color: Colors.cyanAccent,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/55.png", // รูปภาพที่เพิ่ม
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(height: 10), // เพิ่มระยะห่าง
                                Text('รีดเท่านั้น',
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 30.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Service4(),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: 150,
                          color: Colors.yellowAccent,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/66.png", // รูปภาพที่เพิ่ม
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(height: 10), // เพิ่มระยะห่าง
                                Text('เครื่องนอนและอื่นๆ',
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Service5(),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: 150,
                          color: Colors.blueGrey,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/77.png", // รูปภาพที่เพิ่ม
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(height: 10), // เพิ่มระยะห่าง
                                Text('ซักชุดสูท',
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
            icon: Icon(Icons.shopping_bag_rounded),
            label: 'ตะกร้าของฉัน',
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

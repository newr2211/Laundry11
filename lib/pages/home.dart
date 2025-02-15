import 'package:Laundry/pages/bookinghistory.dart';
import 'package:Laundry/pages/detail.dart';
import 'package:Laundry/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:Laundry/pages/booking.dart';
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
  List<String> selectedServices = [];
  List<String> selectedPrices = [];

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

  void updateSelection() {
    setState(() {});
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
                  ...[
                    {'service': 'ซักเสื้อผ้าทั่วไป', 'price': '300฿'},
                    {'service': 'ซักผ้าปูที่นอน,ฝูก', 'price': '1000฿'},
                    {'service': 'ซักชุดนักเรียน,สูท', 'price': '400฿'},
                    {'service': 'ซักผ้าม่าน', 'price': '500฿'},
                    {'service': 'ซักรองเท้า', 'price': '150฿'},
                    {'service': 'ซักรองเท้าหนัง', 'price': '500฿'}
                  ].map((item) => ServiceTile(
                        service: item['service']!,
                        price: item['price']!,
                        updateParent: updateSelection,
                        selectedServices: selectedServices,
                        selectedPrices: selectedPrices,
                      )),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedServices.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detail(
                                  selectedServices: selectedServices,
                                  selectedPrices: selectedPrices,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedServices.isNotEmpty
                          ? Colors.orange
                          : Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Center(
                        child: Text("ไปยังรายการ",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white))),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingHistory(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Center(
                        child: Text("ประวัติการจอง",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white))),
                  ),
                ],
              ),
            ),
    );
  }
}

class ServiceTile extends StatefulWidget {
  final String service, price;
  final Function updateParent;
  final List<String> selectedServices;
  final List<String> selectedPrices;

  const ServiceTile({
    super.key,
    required this.service,
    required this.price,
    required this.updateParent,
    required this.selectedServices,
    required this.selectedPrices,
  });

  @override
  _ServiceTileState createState() => _ServiceTileState();
}

class _ServiceTileState extends State<ServiceTile> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          if (isSelected) {
            widget.selectedServices.add(widget.service);
            widget.selectedPrices.add(widget.price);
          } else {
            widget.selectedServices.remove(widget.service);
            widget.selectedPrices.remove(widget.price);
          }
        });
        widget.updateParent();
      },
      child: Card(
        color: isSelected ? Colors.green : Colors.white,
        child: ListTile(
          title: Text(widget.service, style: TextStyle(fontSize: 18)),
          subtitle: Text(widget.price, style: TextStyle(fontSize: 16)),
          trailing: Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank),
        ),
      ),
    );
  }
}

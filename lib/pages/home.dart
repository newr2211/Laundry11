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
  List<String> selectedServices = []; // เก็บบริการที่เลือก
  List<String> selectedPrices = []; // เก็บราคาของบริการที่เลือก

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
    setState(() {}); // อัปเดต UI ทันที
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Container(
              margin: EdgeInsets.only(top: 70.0, left: 20.0, right: 20.0),
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
                            "Welcome",
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            userName,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 212, 181, 43),
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
                      )
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Divider(color: Colors.black, thickness: 2.0),
                  SizedBox(height: 5.0),
                  Text(
                    "บริการ",
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  ServiceTile(
                      service: 'ซักเสื้อผ้าทั่วไป',
                      price: '300฿',
                      imagePath: 'images/logo.png',
                      updateParent: updateSelection,
                      selectedServices: selectedServices,
                      selectedPrices: selectedPrices),
                  ServiceTile(
                      service: 'ซักผ้าปูที่นอน,ฝูก',
                      price: '1000฿',
                      imagePath: 'images/logo.png',
                      updateParent: updateSelection,
                      selectedServices: selectedServices,
                      selectedPrices: selectedPrices),
                  ServiceTile(
                      service: 'ซักชุดนักเรียน,สูท',
                      price: '400฿',
                      imagePath: 'images/logo.png',
                      updateParent: updateSelection,
                      selectedServices: selectedServices,
                      selectedPrices: selectedPrices),
                  ServiceTile(
                      service: 'ซักผ้าม่าน',
                      price: '500฿',
                      imagePath: 'images/logo.png',
                      updateParent: updateSelection,
                      selectedServices: selectedServices,
                      selectedPrices: selectedPrices),
                  ServiceTile(
                      service: 'ซักรองเท้า',
                      price: '150฿',
                      imagePath: 'images/logo.png',
                      updateParent: updateSelection,
                      selectedServices: selectedServices,
                      selectedPrices: selectedPrices),
                  ServiceTile(
                      service: 'ซักรองเท้าหนัง',
                      price: '500฿',
                      imagePath: 'images/logo.png',
                      updateParent: updateSelection,
                      selectedServices: selectedServices,
                      selectedPrices: selectedPrices),
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
                          : Colors.grey,
                    ),
                    child: Center(child: Text("ไปยังรายการ")),
                  ),
                ],
              ),
            ),
    );
  }
}

class ServiceTile extends StatefulWidget {
  final String service, price, imagePath;
  final Function updateParent;
  final List<String> selectedServices;
  final List<String> selectedPrices;

  const ServiceTile({
    super.key,
    required this.service,
    required this.price,
    required this.imagePath,
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
        widget.updateParent(); // แจ้งให้ Home อัปเดต UI
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(widget.imagePath, height: 50),
            Text(
              widget.service,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.price,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

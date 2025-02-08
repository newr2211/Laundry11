import 'package:Laundry/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:Laundry/pages/booking.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn()), // นำไปหน้าล็อกอิน
      );
    } catch (e) {
      print('Error during sign out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
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
                      "Welcome,",
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "User",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 212, 181, 43),
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // ปุ่มล็อกเอ้าท์
                GestureDetector(
                  onTap: logOut,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    decoration: BoxDecoration(
                      color: Colors.red, // สีปุ่ม
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Icon(Icons.logout),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Divider(),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "บริการ",
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                _service(service: 'ซักเสื้อผ้าทั่วไป', price: '300฿'),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                _service(service: 'ซักผ้าปูที่นอน,ฝูก', price: '1000฿'),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                _service(service: 'ซักชุดนักเรียน,สูท', price: '400฿'),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                _service(service: 'ซักผ้าม่าน', price: '500฿'),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                _service(service: 'ซักรองเท้า', price: '150฿'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _service extends StatefulWidget {
  String service, price;
  _service({super.key, required this.service, required this.price});

  @override
  State<_service> createState() => _serviceState();
}

class _serviceState extends State<_service> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Booking(
                        service: widget.service,
                        price: widget.price,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.orange, borderRadius: BorderRadius.circular(10)),
          height: 100.0,
          // width: 120.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.service,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.price,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

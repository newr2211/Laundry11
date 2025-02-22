import 'package:Laundry/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';

class Booking extends StatefulWidget {
  final String service, price;
  const Booking({
    super.key,
    required this.service,
    required this.price,
    required List selectedPrices,
    required List selectedServices,
    required int totalPrice,
  });

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String? name, email, additionalMessage, deliveryAddress;
  bool isLoading = true;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isLoading = false;
      });
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
          name = data['Name'] ?? 'ไม่ระบุชื่อ';
          email = data['Email'] ?? 'ไม่ระบุอีเมล';
          isLoading = false;
        });
      } else {
        setState(() {
          name = 'ไม่ระบุชื่อ';
          email = 'ไม่ระบุอีเมล';
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _bookService() async {
    if (name == null || email == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("กรุณาล็อกอินก่อนทำการจอง"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    Map<String, dynamic> userBookingMap = {
      "Service": widget.service,
      "Price": widget.price,
      "Date": _selectedDate.toString().split(' ')[0],
      "Time": _selectedTime.format(context),
      "Username": name,
      "Email": email,
      "AdditionalMessage": additionalMessage ?? '',
      "DeliveryAddress": deliveryAddress ?? '', // บันทึกที่อยู่ในการจัดส่ง
    };

    try {
      await FirebaseFirestore.instance
          .collection("Bookings")
          .add(userBookingMap);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("จองบริการสำเร็จ!"),
        backgroundColor: Colors.green,
      ));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("เกิดข้อผิดพลาดในการจอง: $error"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  SizedBox(height: 30.0),
                  _buildDatePicker(),
                  SizedBox(height: 20.0),
                  _buildTimePicker(),
                  SizedBox(height: 20.0),
                  _buildDeliveryAddressField(), // ช่องใส่ที่อยู่
                  SizedBox(height: 40.0),
                  _buildBookButton()
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.blue[700]),
          onPressed: () => Navigator.pop(context),
        ),
        Text(
          "เลือกวันที่และเวลา",
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700]),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text("เลือกวันที่",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0),
          TableCalendar(
            focusedDay: _selectedDate,
            firstDay: DateTime.utc(2025, 1, 1),
            lastDay: DateTime.utc(2030, 1, 1),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
            onDaySelected: (day, _) => setState(() => _selectedDate = day),
            calendarStyle: CalendarStyle(
              selectedDecoration:
                  BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              todayDecoration:
                  BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.alarm, color: Colors.black),
            SizedBox(width: 15.0),
            Text(_selectedTime.format(context),
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryAddressField() {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: TextField(
        decoration: InputDecoration(
          hintText: "กรอกที่อยู่สำหรับจัดส่ง",
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            deliveryAddress = value;
          });
        },
      ),
    );
  }

  Widget _buildBookButton() {
    return ElevatedButton(
      onPressed: _bookService,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: EdgeInsets.symmetric(vertical: 15.0),
      ),
      child: Center(
        child: Text("จองเลย!",
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}

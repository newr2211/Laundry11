import 'package:Laundry/pages/bookinghistory.dart';
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
  });

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String? name, email;
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
    if (name == null ||
        email == null ||
        name == 'ไม่ระบุชื่อ' ||
        email == 'ไม่ระบุอีเมล') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("ไม่สามารถจองได้ กรุณาล็อกอินก่อน"),
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
    };

    try {
      await FirebaseFirestore.instance
          .collection("Bookings")
          .add(userBookingMap)
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("จองบริการสำเร็จ!"),
          backgroundColor: Colors.green,
        ));

        // ไปที่หน้ารายละเอียดการจองทั้งหมด
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingHistory(),
          ),
        );
      });
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
      backgroundColor: Colors.blue,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 30.0),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  _buildDatePicker(),
                  SizedBox(height: 20.0),
                  _buildTimePicker(),
                  SizedBox(height: 40.0),
                  _buildBookButton()
                ],
              ),
            ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text("กรุณาเลือกวันที่",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          Text(_selectedDate.toString().split(' ')[0],
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
          TableCalendar(
            availableGestures: AvailableGestures.all,
            focusedDay: _selectedDate,
            firstDay: DateTime.utc(2025, 01, 01),
            lastDay: DateTime.utc(2030, 01, 01),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
            onDaySelected: (day, focusDay) {
              setState(() {
                _selectedDate = day;
              });
            },
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
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.orange, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text("กรุณาเลือกเวลา",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => _selectTime(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.alarm, color: Colors.white, size: 30.0),
                SizedBox(width: 20.0),
                Text(_selectedTime.format(context),
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    return GestureDetector(
      onTap: _bookService,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 14,
        decoration: BoxDecoration(
            color: Colors.orange, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text("จองเลย !",
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      ),
    );
  }
}

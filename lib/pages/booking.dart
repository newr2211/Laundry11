import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'BookingHistory.dart';

class Booking extends StatefulWidget {
  final List<String> selectedServices;
  final List<String> selectedPrices;

  Booking({
    super.key,
    required this.selectedServices,
    required this.selectedPrices,
    required String service,
    required String price,
  });

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String? name, email;
  bool isLoading = true;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  // ฟังก์ชันดึงข้อมูลผู้ใช้จาก Firebase
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
      if (!userDoc.exists) {
        // ถ้าผู้ใช้ยังไม่มีข้อมูลใน Firestore ให้สร้างข้อมูลใหม่
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'Name': user.displayName ?? 'ไม่ระบุชื่อ',
          'Email': user.email ?? 'ไม่ระบุอีเมล',
        });
      }
      setState(() {
        name = user.displayName ?? 'ไม่ระบุชื่อ';
        email = user.email ?? 'ไม่ระบุอีเมล';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ฟังก์ชันสำหรับเลือกเวลา
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // ฟังก์ชันการจองบริการ
  Future<void> _bookService() async {
    if (name == null || email == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("ไม่สามารถจองได้ กรุณาล็อกอินก่อน"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    Map<String, dynamic> userBookingMap = {
      "Services": widget.selectedServices,
      "Prices": widget.selectedPrices,
      "Date": _selectedDate.toString().split(' ')[0],
      "Time": _selectedTime.format(context),
      "Username": name,
      "Email": email,
    };

    await FirebaseFirestore.instance
        .collection("Bookings")
        .add(userBookingMap)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("จองบริการสำเร็จ!"),
        backgroundColor: Colors.green,
      ));

      // นำทางไปยังหน้า BookingHistory หลังจากจองเสร็จ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookingHistory()),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("เกิดข้อผิดพลาดในการจอง: $error"),
        backgroundColor: Colors.red,
      ));
    });
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
                  _buildBookingSummary(), // แสดงข้อมูลการจอง
                  SizedBox(height: 20.0),
                  _buildBookButton(),
                ],
              ),
            ),
    );
  }

  // ฟังก์ชันสำหรับเลือกวันที่
  Widget _buildDatePicker() {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.orange, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text("กรุณาเลือกวันที่",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text(_selectedDate.toString().split(' ')[0],
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          TableCalendar(
            availableGestures: AvailableGestures.all,
            focusedDay: _selectedDate,
            firstDay: DateTime.utc(2025, 01, 01),
            lastDay: DateTime.utc(2030, 01, 01),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
            onDaySelected: (day, _) {
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

  // ฟังก์ชันสำหรับเลือกเวลา
  Widget _buildTimePicker() {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.orange, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text("กรุณาเลือกเวลา",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          GestureDetector(
            onTap: () => _selectTime(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.alarm, color: Colors.white, size: 30.0),
                SizedBox(width: 20.0),
                Text(_selectedTime.format(context),
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสำหรับแสดงข้อมูลการจอง
  Widget _buildBookingSummary() {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text("สรุปการจอง:",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          ...List.generate(widget.selectedServices.length, (index) {
            return Text(
              "${widget.selectedServices[index]} - ${widget.selectedPrices[index]}",
              style: TextStyle(fontSize: 16.0),
            );
          }),
          Text("วันที่: ${_selectedDate.toString().split(' ')[0]}",
              style: TextStyle(fontSize: 16.0)),
          Text("เวลา: ${_selectedTime.format(context)}",
              style: TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }

  // ฟังก์ชันปุ่มจอง
  Widget _buildBookButton() {
    return GestureDetector(
      onTap: _bookService,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 14,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text("จองเลย !",
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
      ),
    );
  }
}

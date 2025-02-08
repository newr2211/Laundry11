import 'package:flutter/material.dart';
import 'package:Laundry/services/database.dart';

class Booking extends StatefulWidget {
  String service, price;
  Booking({super.key, required this.service, required this.price});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String? name, image, email;

  getthedatafromsharedpref() async {
    // name = await SharedpreferenceHelper().getUserName();
    // image = await SharedpreferenceHelper().getUserImage();
    // email = await SharedpreferenceHelper().getUserEmail();
    setState(() {});
  }

  getontheload() async {
    await getthedatafromsharedpref();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  DateTime _selectedDate = DateTime.now();

  // ฟังก์ชันแก้ไข: _selectDate ให้เหมือนกับ _selectTime
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // อัพเดตวันที่ที่เลือก
      });
    }
  }

  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked; // อัพเดตเวลาเมื่อเลือก
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "เลือกบริการ:",
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.service,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ราคา:",
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.price,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20)),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text(
                    "กรุณาเลือกวันที่",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context); // เรียก _selectDate เมื่อกดที่นี่
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20)),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text(
                    "กรุณาเลือกเวลา",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectTime(context); // เรียก _selectTime เมื่อกดที่นี่
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.alarm,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          _selectedTime.format(context),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            GestureDetector(
              onTap: () async {
                Map<String, dynamic> userBookingmap = {
                  "Service": widget.service,
                  "Date":
                      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"
                          .toString(),
                  "Time": _selectedTime.format(context).toString(),
                  "Username": name,
                  "Image": image,
                  "Email": email,
                };
                await DatabaseMethods()
                    .addUserBooking(userBookingmap)
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    "Service has been booked Successfully!!!",
                    style: TextStyle(fontSize: 20.0),
                  )));
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "จองเลย !",
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

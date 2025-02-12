import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userEmail;
  bool isLoading = true;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<String> selectedServices = [];
  List<String> servicePrices = [];

  @override
  void initState() {
    super.initState();
    getUserEmail();
  }

  // ฟังก์ชันดึงอีเมลของผู้ใช้ที่ล็อกอิน
  void getUserEmail() async {
    User? user = _auth.currentUser;
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

  // ฟังก์ชันสำหรับการจองบริการ
  Future<void> bookService() async {
    if (userEmail == null || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("กรุณากรอกข้อมูลให้ครบถ้วน"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // สร้างข้อมูลการจอง
    Map<String, dynamic> bookingData = {
      "Service": selectedServices,
      "Price": servicePrices,
      "Date": selectedDate?.toString().split(' ')[0],
      "Time": selectedTime?.format(context),
      "Email": userEmail,
      "Username": _auth.currentUser?.displayName ?? "ผู้ใช้ไม่ระบุ",
    };

    // บันทึกการจองลง Firestore
    await FirebaseFirestore.instance
        .collection("Bookings")
        .add(bookingData)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("จองบริการสำเร็จ!"),
        backgroundColor: Colors.green,
      ));
      // นำทางไปยังหน้า BookingHistory
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

  // ฟังก์ชันเลือกวันที่
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  // ฟังก์ชันเลือกเวลา
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("จองบริการ"),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userEmail == null
              ? Center(child: Text("กรุณาล็อกอินก่อน"))
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "เลือกวันที่และเวลา",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text(selectedDate == null
                            ? "เลือกวันที่"
                            : "${selectedDate!.toLocal()}".split(' ')[0]),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _selectTime(context),
                        child: Text(selectedTime == null
                            ? "เลือกเวลา"
                            : selectedTime!.format(context)),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "เลือกบริการ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // รายการบริการที่มี
                      CheckboxListTile(
                        title: Text("ซักผ้า"),
                        value: selectedServices.contains("ซักผ้า"),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedServices.add("ซักผ้า");
                              servicePrices.add("100 บาท");
                            } else {
                              selectedServices.remove("ซักผ้า");
                              servicePrices.remove("100 บาท");
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text("รีดผ้า"),
                        value: selectedServices.contains("รีดผ้า"),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedServices.add("รีดผ้า");
                              servicePrices.add("50 บาท");
                            } else {
                              selectedServices.remove("รีดผ้า");
                              servicePrices.remove("50 บาท");
                            }
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: bookService,
                        child: Text("ยืนยันการจอง"),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class BookingHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ประวัติการจองคิว"),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Bookings")
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
                  leading: Icon(Icons.event, color: Colors.orange, size: 40),
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

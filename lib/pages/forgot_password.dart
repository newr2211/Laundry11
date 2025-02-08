import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // เพิ่มการใช้งาน FirebaseAuth
import 'package:Laundry/pages/home.dart'; // เพิ่มหน้า Home หรือหน้าอื่นที่ต้องการไปหลังรีเซ็ตรหัสผ่านสำเร็จ

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String? email;
  TextEditingController mailcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  // ฟังก์ชันรีเซ็ตรหัสผ่าน
  resetPassword() async {
    try {
      // ส่งอีเมลรีเซ็ตรหัสผ่าน
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
      // หากสำเร็จ ให้แสดงข้อความ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ส่งอีเมลรีเซ็ตรหัสผ่านแล้ว'),
        ),
      );
      // นำทางไปที่หน้า Login หรือหน้าอื่นๆ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Home()), // ไปที่หน้า Home หรือหน้าที่ต้องการ
      );
    } catch (e) {
      // หากมีข้อผิดพลาด ให้แสดงข้อความข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue,
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 70.0,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Password Recovery",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Enter your mail",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30.0,
            ),
            Form(
              key: _formkey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70, width: 2.0),
                    borderRadius: BorderRadius.circular(30)),
                child: TextFormField(
                  controller: mailcontroller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email",
                      hintStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                      prefixIcon: Icon(
                        Icons.mail_outline,
                        color: Colors.white60,
                        size: 30.0,
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            GestureDetector(
              onTap: () async {
                if (_formkey.currentState!.validate()) {
                  setState(() {
                    email = mailcontroller.text;
                  });
                  resetPassword(); // เรียกฟังก์ชันรีเซ็ตรหัสผ่าน
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Send Email",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

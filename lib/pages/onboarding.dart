import 'package:flutter/material.dart';
import 'package:Laundry/pages/home.dart';
import 'package:Laundry/pages/login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // เปลี่ยนพื้นหลังให้ดูเบาๆ
      body: Padding(
        padding: const EdgeInsets.only(top: 120.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // จัดตำแหน่งให้โลโก้และปุ่มอยู่กลาง
          children: [
            // โลโก้ที่มีขนาดใหญ่และอยู่กลาง
            Container(
              margin: const EdgeInsets.only(bottom: 60.0),
              child: Center(
                child: Image.asset(
                  "images/logo.png",
                  width: 200, // ขนาดของโลโก้ที่เหมาะสม
                  height: 200,
                ),
              ),
            ),
            // ปุ่มที่มีขนาดใหญ่และดูเด่นขึ้น
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogIn()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.orange, // ใช้สีที่สะดุดตา
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Welcome Let'go",
                  style: TextStyle(
                    color: Colors.white, // ใช้สีขาวให้ข้อความชัดเจน
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Laundry/pages/home.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .get();
      if (userData.exists) {
        setState(() {
          nameController.text = userData['Name'] ?? '';
          numberController.text = userData['Number'] ?? '';
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user!.uid)
            .update({
          'Name': nameController.text,
          'Number': numberController.text,
        });

        if (passwordController.text.isNotEmpty) {
          await user!.updatePassword(passwordController.text);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("อัปเดตโปรไฟล์สำเร็จ")),
        );

        // เปลี่ยนไปหน้า Home หลังจากอัปเดตข้อมูลสำเร็จ
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("แก้ไขโปรไฟล์")),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false, // เอาลูกศรย้อนกลับออก
      ),
      body: Center(
        // ใช้ Center widget เพื่อจัดกลาง
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // จัดให้อยู่กลาง
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ชื่อ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "กรอกชื่อ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'กรุณาใส่ชื่อ' : null,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "เบอร์โทร",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "กรอกเบอร์โทร",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'กรุณาใส่เบอร์โทร' : null,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "รหัสผ่านใหม่ (ถ้ามี)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "กรอกรหัสผ่านใหม่",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "บันทึกการเปลี่ยนแปลง",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

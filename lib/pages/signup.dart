import 'package:Laundry/pages/home.dart';
import 'package:Laundry/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Laundry/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name = "", email = "", password = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  registration() async {
    if (password != null &&
        nameController.text != "" &&
        emailController.text != "") {
      try {
        // สมัครผู้ใช้ด้วยอีเมลและรหัสผ่าน
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // เอา UID ของผู้ใช้ที่สมัคร
        String? id = userCredential.user?.uid;

        // ถ้าผู้ใช้สมัครสำเร็จ
        if (id != null) {
          // สร้าง Map ของข้อมูลผู้ใช้
          Map<String, dynamic> userInfoMap = {
            "Id": id,
            "Name": nameController.text,
            "Email": emailController.text,
            // ถ้าต้องการบันทึกข้อมูลเพิ่มเติม เช่น หมายเลขโทรศัพท์
            // "Telephone": telephoneController.text,
          };

          // บันทึกข้อมูลผู้ใช้ลงใน Firestore
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(id)
              .set(userInfoMap);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Registered Successfully!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              )));

          // นำผู้ใช้ไปยังหน้า Home
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      } on FirebaseAuthException catch (e) {
        String message = '';
        if (e.code == 'weak-password') {
          message = "Password Provided is too Weak";
        } else if (e.code == 'email-already-in-use') {
          message = "Account Already exists";
        } else {
          message = "Error: ${e.message}"; // แสดงข้อความผิดพลาดจาก Firebase
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              message,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 50.0,
              left: 30.0,
            ),
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(color: Colors.blue),
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Create Your\nAccount",
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: 40.0, left: 30.0, right: 30.0, bottom: 30.0),
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(
                        color: Color(0xFFB91635),
                        fontSize: 23.0,
                        fontWeight: FontWeight.w500),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: "Name",
                        prefixIcon: Icon(Icons.person_outline)),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    "Gmail",
                    style: TextStyle(
                        color: Color(0xFFB91635),
                        fontSize: 23.0,
                        fontWeight: FontWeight.w500),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter E-mail';
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "Gmail",
                        prefixIcon: Icon(Icons.mail_outline)),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    "Password",
                    style: TextStyle(
                        color: Color(0xFFB91635),
                        fontSize: 23.0,
                        fontWeight: FontWeight.w500),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.password_outlined),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (nameController.text != "" &&
                          emailController != "" &&
                          passwordController != "") {
                        setState(() {
                          name = nameController.text;
                          email = emailController.text;
                          password = passwordController.text;
                        });
                      }
                      registration();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xFFB91635),
                            Color(0Xff621d3c),
                            Color(0xFF311937)
                          ]),
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        "SIGN UP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                            color: Color(0xFF311937),
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LogIn()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Sign In",
                          style: TextStyle(
                              color: Color(0Xff621d3c),
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

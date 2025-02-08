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
      backgroundColor: Colors.blue,
      body: Container(
          margin: EdgeInsets.only(top: 120.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(right: 30.0),
                child: Image.asset("images/logo.png"),
              ),
              SizedBox(height: 60.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogIn()));
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  // width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Welcome Let'go",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 245, 245, 245),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

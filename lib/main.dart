import 'package:Laundry/pages/bookinghistory.dart';
import 'package:Laundry/pages/detail.dart';
import 'package:flutter/material.dart';
import 'package:Laundry/pages/booking.dart';
import 'package:Laundry/pages/home.dart';
import 'package:Laundry/pages/login.dart';
import 'package:Laundry/pages/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Laundry/pages/signup.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Onboarding(),
    );
  }
}

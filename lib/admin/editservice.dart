import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Editservice extends StatefulWidget {
  const Editservice({super.key});

  @override
  State<Editservice> createState() => _EditserviceState();
}

class _EditserviceState extends State<Editservice> {
  // ตัวแปรเก็บสถานะการเปิด/ปิดบริการ
  Map<String, bool> serviceAvailability = {
    'service1': true,
    'service2': true,
    'service3': true,
    'service4': true,
    'service5': true,
  };

  @override
  void initState() {
    super.initState();
    // โหลดสถานะจาก Firebase ในการเริ่มต้น
    loadServiceAvailability();
  }

  // ฟังก์ชันโหลดสถานะจาก Firebase
  Future<void> loadServiceAvailability() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('services').get();
      snapshot.docs.forEach((doc) {
        final serviceName = doc.id;
        final isAvailable = doc['isAvailable'] ?? true;
        setState(() {
          serviceAvailability[serviceName] = isAvailable;
        });
      });
    } catch (e) {
      print("Error loading service availability: $e");
    }
  }

  // ฟังก์ชันอัปเดตสถานะใน Firebase
  Future<void> updateServiceStatus(String service, bool isAvailable) async {
    try {
      await FirebaseFirestore.instance
          .collection('services')
          .doc(service)
          .update({'isAvailable': isAvailable});
    } catch (e) {
      print("Error updating service status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("จัดการบริการ"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "จัดการสถานะของบริการ",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Loop ผ่านบริการทั้งหมด
            ...serviceAvailability.keys.map((service) {
              return ListTile(
                title: Text(service),
                trailing: Switch(
                  value: serviceAvailability[service]!,
                  onChanged: (value) {
                    setState(() {
                      serviceAvailability[service] = value;
                    });
                    updateServiceStatus(service, value);
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

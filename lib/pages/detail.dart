import 'package:flutter/material.dart';
import 'package:Laundry/pages/service1.dart';
import 'package:Laundry/pages/service2.dart';
import 'package:Laundry/pages/service3.dart';
import 'package:Laundry/pages/service4.dart';
import 'package:Laundry/pages/service5.dart';
import 'package:Laundry/pages/booking.dart';

class Detail extends StatefulWidget {
  final List<Map<String, dynamic>> selectedServices;
  final List<int> selectedPrices;
  final Function(List<Map<String, dynamic>>, List<int>) onBack;

  Detail({
    required this.selectedServices,
    required this.selectedPrices,
    required this.onBack,
    required void Function(String service, int price) onAddService,
  });

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late List<Map<String, dynamic>> selectedServices;
  late List<int> selectedPrices;

  @override
  void initState() {
    super.initState();
    selectedServices = List.from(widget.selectedServices);
    selectedPrices = List.from(widget.selectedPrices);
  }

  // ฟังก์ชันเพิ่มบริการใหม่
  void onAddService(Map<String, dynamic> newService) {
    setState(() {
      selectedServices.add({'service': newService['service']});
      selectedPrices.add(newService['price']);
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = selectedPrices.fold(0, (prev, amount) => prev + amount);

    return Scaffold(
      appBar: AppBar(
        title: Text("รายละเอียดการจอง",
            style: TextStyle(
                color: Colors.blue[700], fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[50],
        iconTheme: IconThemeData(color: Colors.blue[700]),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.onBack(selectedServices, selectedPrices);
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.blue[50]),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "บริการที่เลือก",
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: selectedServices.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        selectedServices[index]['service'],
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                      trailing: Text(
                        '${selectedPrices[index]}฿',
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(color: Colors.blueGrey, thickness: 2.0),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "รวมทั้งหมด",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                Text(
                  "$totalPrice฿",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // ส่งข้อมูลที่เลือกไปยังหน้า Booking
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Booking(
                      selectedServices: selectedServices,
                      selectedPrices: selectedPrices,
                      totalPrice: totalPrice, // ส่ง totalPrice เป็น int
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              ),
              child: Center(
                child: Text(
                  "เลือกเวลาการจอง",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('ซัก-ผับ'),
                        onTap: () async {
                          Navigator.pop(context); // ปิด BottomSheet ก่อน
                          final newService = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Service1()),
                          );
                          if (newService != null) {
                            onAddService(newService);
                          }
                        },
                      ),
                      ListTile(
                        title: Text('ซักรองเท้า'),
                        onTap: () async {
                          Navigator.pop(context);
                          final newService = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Service2()),
                          );
                          if (newService != null) {
                            onAddService(newService);
                          }
                        },
                      ),
                      ListTile(
                        title: Text('รีดเทานั้น'),
                        onTap: () async {
                          Navigator.pop(context);
                          final newService = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Service3()),
                          );
                          if (newService != null) {
                            onAddService(newService);
                          }
                        },
                      ),
                      ListTile(
                        title: Text('เครื่องนอนและอื่นๆ'),
                        onTap: () async {
                          Navigator.pop(context);
                          final newService = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Service4()),
                          );
                          if (newService != null) {
                            onAddService(newService);
                          }
                        },
                      ),
                      ListTile(
                        title: Text('ซักชุดสูท'),
                        onTap: () async {
                          Navigator.pop(context);
                          final newService = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Service5()),
                          );
                          if (newService != null) {
                            onAddService(newService);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              ),
              child: Center(
                child: Text(
                  "เลือกบริการเพิ่มเติม",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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

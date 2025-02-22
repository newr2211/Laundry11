import 'package:Laundry/pages/detail.dart';
import 'package:flutter/material.dart';

class Service1 extends StatefulWidget {
  @override
  _Service1State createState() => _Service1State();
}

class _Service1State extends State<Service1> {
  int pricePerItem = 0;
  Map<String, int> serviceQuantities = {
    "ซัก-พับ": 0,
    "รีดผ้า": 0,
    "ขจัดคราบ": 0,
    "ให้ผ้าขาวยิ่งขาว": 0,
    "ให้ผ้าดำยิ่งดำ": 0,
    "ให้ยีนส์ยิ่งน้ำเงิน": 0,
  };

  Map<String, int> servicePrices = {
    "ซัก-พับ": 25,
    "รีดผ้า": 15,
    "ขจัดคราบ": 20,
    "ให้ผ้าขาวยิ่งขาว": 15,
    "ให้ผ้าดำยิ่งดำ": 15,
    "ให้ยีนส์ยิ่งน้ำเงิน": 25,
  };

  List<String> selectedServices = []; // เก็บบริการที่เลือก
  List<int> selectedServicePrices = []; // เก็บราคาของบริการที่เลือก

  int get totalPrice {
    return selectedServicePrices.fold(0, (prev, price) => prev + price);
  }

  @override
  void initState() {
    super.initState();
    // กำหนดค่าจำนวนบริการเป็น 0 ทุกตัวเมื่อเริ่มต้น
    serviceQuantities = {
      "ซัก-พับ": 0,
      "รีดผ้า": 0,
      "ขจัดคราบ": 0,
      "ให้ผ้าขาวยิ่งขาว": 0,
      "ให้ผ้าดำยิ่งดำ": 0,
      "ให้ยีนส์ยิ่งน้ำเงิน": 0,
    };
  }

  void updateServiceQuantity(String service, int change) {
    setState(() {
      serviceQuantities[service] =
          (serviceQuantities[service]! + change).clamp(0, 99);

      // คำนวณราคาของบริการที่เลือกใหม่ตามจำนวนที่เปลี่ยน
      if (serviceQuantities[service]! > 0) {
        int index = selectedServices.indexOf(service);
        if (index == -1) {
          selectedServices.add(service);
          selectedServicePrices
              .add(servicePrices[service]! * serviceQuantities[service]!);
        } else {
          selectedServicePrices[index] =
              servicePrices[service]! * serviceQuantities[service]!;
        }
      } else {
        int index = selectedServices.indexOf(service);
        if (index != -1) {
          selectedServices.removeAt(index);
          selectedServicePrices.removeAt(index);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // เพิ่มส่วนของบริการที่เหลือให้เหมือนกับ "ซัก-พับ"
            for (var service in serviceQuantities.keys) ...[
              if (service == "ซัก-พับ") ...[
                // แสดง "ซัก-พับ" แค่ครั้งเดียว
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/111.png", height: 35),
                    SizedBox(width: 10),
                    Text("ซัก-พับ",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/112.png", height: 35),
                    SizedBox(width: 10),
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Image.asset("images/113.png", height: 35),
                    SizedBox(width: 10),
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Image.asset("images/114.png", height: 35),
                    SizedBox(width: 10),
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Image.asset("images/115.png", height: 35),
                  ],
                ),
                SizedBox(height: 20),
              ],
              // เพิ่มสวิตช์และเลือกจำนวนบริการอื่นๆ
              _buildSwitch(service, serviceQuantities[service]! > 0, (value) {
                setState(() {
                  serviceQuantities[service] = value ? 1 : 0;
                });
              }),
              if (serviceQuantities[service]! > 0)
                _buildQuantitySelector(
                    service,
                    serviceQuantities[service]!,
                    (val) => updateServiceQuantity(
                        service, val - serviceQuantities[service]!)),
              SizedBox(height: 20),
            ],
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          // สร้างรายการบริการที่เลือก
          List<Map<String, dynamic>> selectedServices = [];
          List<int> selectedPrices = [];

          serviceQuantities.forEach((service, quantity) {
            if (quantity > 0) {
              selectedServices.add({
                'service': service, // ชื่อบริการ
              });
              selectedPrices.add(servicePrices[service]! * quantity); // ราคา
            }
          });

          // นำข้อมูลไปที่หน้า Detail
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Detail(
                selectedServices: selectedServices,
                selectedPrices: selectedPrices,
                onBack: (List<Map<String, dynamic>> selectedServices,
                    List<int> selectedPrices) {
                  // ที่นี่คุณสามารถจัดการข้อมูลที่ได้รับกลับมา
                  print(selectedServices);
                  print(selectedPrices);
                },
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text("เพิ่มไปยังตะกร้า",
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  Widget _buildQuantitySelector(
      String label, int quantity, Function(int) onQuantityChanged) {
    int itemPrice = servicePrices[label] ?? pricePerItem;

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label ตัวละ ฿$itemPrice", style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Row(
            children: [
              Text("฿${quantity * itemPrice}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              Spacer(),
              IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: quantity > 0
                      ? () => onQuantityChanged(quantity - 1)
                      : null),
              Text("$quantity", style: TextStyle(fontSize: 18)),
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => onQuantityChanged(quantity + 1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

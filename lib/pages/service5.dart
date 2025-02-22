import 'package:flutter/material.dart';
import 'package:Laundry/pages/detail.dart'; // Import your existing Detail page

class Service5 extends StatefulWidget {
  @override
  _Service5State createState() => _Service5State();
}

class _Service5State extends State<Service5> {
  int pricePerItem = 0;

  Map<String, int> serviceQuantities = {
    "เสื้อแจ็คเก็ตสูท,เสื้อกั๊ก,เสื้อกั๊กชั้นนอก": 0,
    "กางเกงสูท,กางเกง,กระโปรง": 0,
    "เสื้อโค้ท,แจ็คเก็ต,ชุดกระโปรง": 0,
    "เน็คไท,ผ้าพันคอ": 0,
  };

  Map<String, int> servicePrices = {
    "เสื้อแจ็คเก็ตสูท,เสื้อกั๊ก,เสื้อกั๊กชั้นนอก": 95,
    "กางเกงสูท,กางเกง,กระโปรง": 95,
    "เสื้อโค้ท,แจ็คเก็ต,ชุดกระโปรง": 200,
    "เน็คไท,ผ้าพันคอ": 50,
  };

  int get totalPrice {
    int extraServicesPrice = serviceQuantities.entries
        .map(
            (entry) => entry.value * (servicePrices[entry.key] ?? pricePerItem))
        .fold(0, (prev, amount) => prev + amount);
    return extraServicesPrice;
  }

  void updateServiceQuantity(String service, int change) {
    setState(() {
      serviceQuantities[service] =
          (serviceQuantities[service]! + change).clamp(0, 99);
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
            // แสดงหัวข้อของบริการ
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/77.png", height: 35),
                SizedBox(width: 10),
                Text("ซักชุดสูท",
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/11.png", height: 35),
                SizedBox(width: 10),
                Icon(Icons.add),
                SizedBox(width: 10),
                Image.asset("images/12.png", height: 35),
                SizedBox(width: 10),
                Icon(Icons.add),
                SizedBox(width: 10),
                Image.asset("images/13.png", height: 35),
                SizedBox(width: 10),
                Icon(Icons.add),
                SizedBox(width: 10),
                Image.asset("images/14.png", height: 35),
              ],
            ),
            SizedBox(height: 20),

            // เพิ่มส่วนของบริการที่เหลือให้เหมือนกับ "ซัก-พับ"
            for (var service in serviceQuantities.keys) ...[
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
              SizedBox(height: 10),
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
        child: Text("เพิ่มไปยังตะกร้า - ฿$totalPrice",
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

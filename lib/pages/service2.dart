import 'package:flutter/material.dart';

class Service2 extends StatefulWidget {
  @override
  _Service2State createState() => _Service2State();
}

class _Service2State extends State<Service2> {
  int pricePerItem = 0;

  Map<String, int> serviceQuantities = {
    "ซักรองเท้า": 0,
    "น้ำหอมรองเท้า": 0,
    "ทำความสะอาดด้วยเทคนิคพิเศษ": 0,
  };

  Map<String, int> servicePrices = {
    "ซักรองเท้า": 400,
    "น้ำหอมรองเท้า": 150,
    "ทำความสะอาดด้วยเทคนิคพิเศษ": 200,
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
            // เพิ่มส่วนของบริการที่เหลือให้เหมือนกับ "ซักรองเท้า"
            for (var service in serviceQuantities.keys) ...[
              if (service == "ซักรองเท้า") ...[
                // แสดง "ซักรองเท้า" แค่ครั้งเดียว
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/44.png", height: 35),
                    SizedBox(width: 10),
                    Text("ซักรองเท้า",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/21.png", height: 35),
                    SizedBox(width: 10),
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Image.asset("images/22.png", height: 35),
                    SizedBox(width: 10),
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Image.asset("images/23.png", height: 35),
                    SizedBox(width: 10),
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Image.asset("images/24.png", height: 35),
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
              SizedBox(height: 10),
            ],
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          // เพิ่มการนำทางไปยังหน้าใหม่ (หน้า Detail หรือ Cart)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(cart: serviceQuantities),
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
          Text("$label คู่ละ ฿$itemPrice", style: TextStyle(fontSize: 16)),
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

// หน้า DetailScreen หรือ Cart
class DetailScreen extends StatelessWidget {
  final Map<String, int> cart;
  DetailScreen({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("รายละเอียดตะกร้า")),
      body: ListView(
        children: cart.entries
            .map((entry) => ListTile(
                  title: Text(entry.key),
                  subtitle: Text("จำนวน: ${entry.value}"),
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // กลับไปหน้าหลัก
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}

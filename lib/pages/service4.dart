import 'package:flutter/material.dart';

class Service4 extends StatefulWidget {
  @override
  _Service4State createState() => _Service4State();
}

class _Service4State extends State<Service4> {
  int quantity = 1;
  int pricePerItem = 25;

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

  Map<String, TextEditingController> serviceControllers = {};

  @override
  void initState() {
    super.initState();
    // สร้าง TextEditingController สำหรับแต่ละบริการ
    serviceQuantities.keys.forEach((service) {
      serviceControllers[service] = TextEditingController();
    });
  }

  @override
  void dispose() {
    // ทำการ dispose เมื่อไม่ใช้
    serviceControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  int get totalPrice {
    int basePrice = quantity * pricePerItem;
    int extraServicesPrice = serviceQuantities.entries
        .map(
            (entry) => entry.value * (servicePrices[entry.key] ?? pricePerItem))
        .fold(0, (prev, amount) => prev + amount);
    return basePrice + extraServicesPrice;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/111.png", height: 35),
                SizedBox(width: 10),
                Text("ซัก-พับ",
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
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
            _buildQuantitySelector(
                "ซัก-พับ", quantity, (val) => setState(() => quantity = val)),
            SizedBox(height: 20),
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
        onPressed: () {},
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

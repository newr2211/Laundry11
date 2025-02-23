import 'package:flutter/material.dart';
import 'package:Laundry/pages/detail.dart'; // Import the detail page

class Service4 extends StatefulWidget {
  @override
  _Service4State createState() => _Service4State();
}

class _Service4State extends State<Service4> {
  int pricePerItem = 0;

  Map<String, int> serviceQuantities = {
    "เครื่องนอนที่ไม่หนา": 0,
    "เครื่องนอนที่หนา": 0,
    "ปลอกหมอน,ปลอกหมอนกันเปื้อน": 0,
    "หมอน,หมอนอิง,หมอนข้าง": 0,
    "ผ้าคลุมโซฟา,ปลอกโซฟา": 0,
  };

  Map<String, int> servicePrices = {
    "เครื่องนอนที่ไม่หนา": 150,
    "เครื่องนอนที่หนา": 250,
    "ปลอกหมอน,ปลอกหมอนกันเปื้อน": 30,
    "หมอน,หมอนอิง,หมอนข้าง": 150,
    "ผ้าคลุมโซฟา,ปลอกโซฟา": 200,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/66.png", height: 35),
                SizedBox(width: 10),
                Text("เครื่องนอนและอื่นๆ",
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/1.png", height: 35),
                SizedBox(width: 10),
                Icon(Icons.add),
                SizedBox(width: 10),
                Image.asset("images/2.png", height: 35),
                SizedBox(width: 10),
                Icon(Icons.add),
                SizedBox(width: 10),
                Image.asset("images/3.png", height: 35),
                SizedBox(width: 10),
                Icon(Icons.add),
                SizedBox(width: 10),
                Image.asset("images/4.png", height: 35),
              ],
            ),
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
        onPressed: () {
          // Create a list of selected services and their prices
          List<Map<String, dynamic>> selectedServices = [];
          List<int> selectedPrices = [];

          serviceQuantities.forEach((service, quantity) {
            if (quantity > 0) {
              selectedServices.add({
                'service': service,
                'price': servicePrices[service]!,
                'quantity': quantity,
              });
              selectedPrices.add(servicePrices[service]! * quantity);
            }
          });

          // Pass selected services and prices to the Detail page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Detail(
                selectedServices: selectedServices,
                selectedPrices: selectedPrices,
                onBack: (List<Map<String, dynamic>> updatedServices,
                    List<int> updatedPrices) {
                  // Handle any data updates if needed
                  print(updatedServices);
                  print(updatedPrices);
                },
                onAddService: (String service, int price) {},
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
          Text("$label  ฿$itemPrice", style: TextStyle(fontSize: 16)),
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

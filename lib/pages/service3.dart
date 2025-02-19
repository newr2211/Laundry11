import 'package:flutter/material.dart';

class Service2 extends StatefulWidget {
  @override
  _Service2State createState() => _Service2State();
}

class _Service2State extends State<Service2> {
  int quantity = 1; // จำนวนชิ้นเริ่มต้น
  int pricePerItem = 25; // ราคาต่อชิ้น
  bool isServiceEnabled = false; // เริ่มต้นสวิตซ์รีดผ้าปิด
  bool isStainRemovalEnabled = false; // สวิตซ์สำหรับขจัดคราบ
  bool isWhiteBrighteningEnabled = false; // สวิตซ์ให้ผ้าขาวยิ่งขาว
  bool isBlackBrighteningEnabled = false; // สวิตซ์ให้ผ้าดำยิ่งดำ
  bool isDenimBlueEnabled = false; // สวิตซ์ให้ยีนส์ยิ่งน้ำเงิน
  int premiumPrice = 15; // ราคาน้ำยารีดผ้า
  int stainRemovalPrice = 20; // ราคาขจัดคราบ
  int whiteBrighteningPrice = 18; // ราคาผ้าขาวยิ่งขาว
  int blackBrighteningPrice = 18; // ราคาผ้าดำยิ่งดำ
  int denimBluePrice = 25; // ราคายีนส์ยิ่งน้ำเงิน

  // คำนวณราคารวม
  int get totalPrice {
    int basePrice = quantity * pricePerItem;
    int premiumTotal = isServiceEnabled ? quantity * premiumPrice : 0;
    int stainRemovalTotal =
        isStainRemovalEnabled ? quantity * stainRemovalPrice : 0;
    int whiteBrighteningTotal =
        isWhiteBrighteningEnabled ? quantity * whiteBrighteningPrice : 0;
    int blackBrighteningTotal =
        isBlackBrighteningEnabled ? quantity * blackBrighteningPrice : 0;
    int denimBlueTotal = isDenimBlueEnabled ? quantity * denimBluePrice : 0;

    return basePrice +
        premiumTotal +
        stainRemovalTotal +
        whiteBrighteningTotal +
        blackBrighteningTotal +
        denimBlueTotal;
  }

  // ฟังก์ชันเพิ่มจำนวน
  void increment() {
    setState(() {
      quantity++;
    });
  }

  // ฟังก์ชันลดจำนวน
  void decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
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
            // Row for image and text "ซัก-พับ" in center
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // จัดให้อยู่ตรงกลาง
              crossAxisAlignment:
                  CrossAxisAlignment.center, // จัดให้อยู่ตรงกลางในแนวตั้ง
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
            Text("เลือกจำนวนชิ้น",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ค่าบริการซัก-พับ ตัวละ $pricePerItem บาท",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("฿${quantity * pricePerItem}",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.remove), onPressed: decrement),
                      Text("$quantity", style: TextStyle(fontSize: 18)),
                      IconButton(icon: Icon(Icons.add), onPressed: increment),
                    ],
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "โปรดแจ้งความต้องการเพิ่มเติม (ถ้ามี)"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // สวิตซ์สำหรับรีดผ้า
            _buildSwitch("รีดผ้า", isServiceEnabled, (value) {
              setState(() {
                isServiceEnabled = value;
              });
            }),
            if (isServiceEnabled)
              _buildServiceDetail("รีดผ้า", premiumPrice, "assets/iron.png"),
            // สวิตซ์สำหรับบริการเสริมต่างๆ
            _buildSwitch("ขจัดคราบ", isStainRemovalEnabled, (value) {
              setState(() {
                isStainRemovalEnabled = value;
              });
            }),
            if (isStainRemovalEnabled)
              _buildServiceDetail(
                  "ขจัดคราบ", stainRemovalPrice, "assets/stain_removal.png"),
            _buildSwitch("ให้ผ้าขาวยิ่งขาว", isWhiteBrighteningEnabled,
                (value) {
              setState(() {
                isWhiteBrighteningEnabled = value;
              });
            }),
            if (isWhiteBrighteningEnabled)
              _buildServiceDetail("ให้ผ้าขาวยิ่งขาว", whiteBrighteningPrice,
                  "assets/white_brightening.png"),
            _buildSwitch("ให้ผ้าดำยิ่งดำ", isBlackBrighteningEnabled, (value) {
              setState(() {
                isBlackBrighteningEnabled = value;
              });
            }),
            if (isBlackBrighteningEnabled)
              _buildServiceDetail("ให้ผ้าดำยิ่งดำ", blackBrighteningPrice,
                  "assets/black_brightening.png"),
            _buildSwitch("ให้ยีนส์ยิ่งน้ำเงิน", isDenimBlueEnabled, (value) {
              setState(() {
                isDenimBlueEnabled = value;
              });
            }),
            if (isDenimBlueEnabled)
              _buildServiceDetail("ให้ยีนส์ยิ่งน้ำเงิน", denimBluePrice,
                  "assets/denim_blue.png"),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text("เพิ่มไปยังตะกร้า - ฿$totalPrice",
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }

  // ฟังก์ชันสำหรับสร้างสวิตซ์
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

  // ฟังก์ชันแสดงรายละเอียดบริการเสริม
  Widget _buildServiceDetail(
      String label, int servicePrice, String imageAsset) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
        ),
        child: Column(
          children: [
            Image.asset(imageAsset, height: 80), // เพิ่มภาพสำหรับบริการ
            SizedBox(height: 10),
            Text("$label ตัวละ ฿$servicePrice", style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Text("฿${quantity * servicePrice}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                Spacer(),
                IconButton(icon: Icon(Icons.remove), onPressed: decrement),
                Text("$quantity", style: TextStyle(fontSize: 18)),
                IconButton(icon: Icon(Icons.add), onPressed: increment),
              ],
            ),
            TextField(
              decoration:
                  InputDecoration(hintText: "โปรดแจ้งความต้องการพิเศษ (ถ้ามี)"),
            ),
          ],
        ),
      ),
    );
  }
}

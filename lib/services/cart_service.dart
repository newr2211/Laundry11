import 'package:flutter/material.dart';

class CartItem {
  final String service;  // ชื่อบริการ
  final int price;       // ราคาบริการ

  CartItem({required this.service, required this.price});
}

class CartService with ChangeNotifier {
  List<CartItem> _items = [];  // รายการของบริการในตะกร้า

  List<CartItem> get items {
    return [..._items];  // คืนค่ารายการบริการทั้งหมด
  }

  int get totalPrice {
    int total = 0;
    for (var item in _items) {
      total += item.price;  // คำนวณราคาทั้งหมด
    }
    return total;
  }

  // ฟังก์ชันเพิ่มรายการเข้าไปในตะกร้า
  void addItem(String service, int price) {
    _items.add(CartItem(service: service, price: price));
    notifyListeners();  // แจ้งให้หน้าจอรู้ว่าเกิดการเปลี่ยนแปลง
  }

  // ฟังก์ชันลบรายการออกจากตะกร้า
  void removeItem(String service) {
    _items.removeWhere((item) => item.service == service);
    notifyListeners();  // แจ้งให้หน้าจอรู้ว่าเกิดการเปลี่ยนแปลง
  }

  // ฟังก์ชันล้างตะกร้าทั้งหมด
  void clear() {
    _items.clear();
    notifyListeners();  // แจ้งให้หน้าจอรู้ว่าเกิดการเปลี่ยนแปลง
  }
}

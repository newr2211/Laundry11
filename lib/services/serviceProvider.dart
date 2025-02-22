import 'package:flutter/material.dart';

class ServiceProvider with ChangeNotifier {
  List<Map<String, dynamic>> _selectedServices = [];
  List<int> _selectedPrices = [];

  List<Map<String, dynamic>> get selectedServices => _selectedServices;
  List<int> get selectedPrices => _selectedPrices;

  void addService(Map<String, dynamic> service, int price) {
    _selectedServices.add(service);
    _selectedPrices.add(price);
    notifyListeners();
  }

  void clearServices() {
    _selectedServices.clear();
    _selectedPrices.clear();
    notifyListeners();
  }
}

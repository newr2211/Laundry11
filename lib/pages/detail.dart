import 'package:Laundry/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartService>(context);
    final List<CartItem> selectedServices = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: Text("ตะกร้าบริการ"),
        backgroundColor: Colors.blue[50],
        iconTheme: IconThemeData(color: Colors.blue[700]),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
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
                        selectedServices[index].service,
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                      trailing: Text(
                        '${selectedServices[index].price}฿',
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                      onLongPress: () {
                        // ลบบริการจากตะกร้า
                        cart.removeItem(selectedServices[index].service);
                      },
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
                  "${cart.totalPrice}฿",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

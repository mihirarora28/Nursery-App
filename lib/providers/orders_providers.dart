import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'cart_provider.dart';
import 'dart:convert';

class OrderItem {
  final String id;
  final double totalAmount;
  final DateTime dateTime;
  final List<Cart> products;
  OrderItem(
      {required this.dateTime,
      required this.id,
      required this.products,
      required this.totalAmount});
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _items = [];

  final AuthToken;

  OrdersProvider(this.AuthToken, this._items);

  List<OrderItem> get items {
    return [..._items];
  }

  Future<void> addItem(
      String id, double totalAmount, List<Cart> products) async {
    var url =
        'https://shopapp2-1c326-default-rtdb.firebaseio.com/orders.json?auth=$AuthToken';
    // products.forEach((element) {
    //   Map<String,dynamic> mapp = {
    //     'id-prod':element.id,
    //     'prod-title':element.title,
    //     'price':element.price,
    //     'quantity':element.quantity
    //   };
    // });
    String timeStamp = DateTime.now().toIso8601String();
    try {
      final response = await https.post(Uri.parse(url),
          body: json.encode({
            'totalAmount': totalAmount,
            'dateTime': timeStamp,
            'products': products
                .map((e) => {
                      'id': e.id,
                      'quantity': e.quantity,
                      'price': e.price,
                      'title': e.title,
                    })
                .toList()
          }));

      _items.add(OrderItem(
          dateTime: DateTime.now(),
          id: id,
          products: products,
          totalAmount: totalAmount));
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  void removeAll() {
    _items = [];
    notifyListeners();
  }

  Future<void> fetchMyOrders() async {
    var url =
        'https://shopapp2-1c326-default-rtdb.firebaseio.com/orders.json?auth=$AuthToken';
    final response = await https.get(Uri.parse(url));
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    print(data);
    final List<OrderItem> newOrder = [];
    data.forEach((key, value) {
      newOrder.add(OrderItem(
          dateTime: DateTime.parse(value['dateTime']),
          id: key,
          products: (value['products'] as List<dynamic>)
              .map((ee) => Cart(
                  id: ee['id'],
                  price: ee['price'],
                  quantity: ee['quantity'],
                  title: ee['title']))
              .toList(),
          totalAmount: value['totalAmount']));
    });
    _items = newOrder.reversed.toList();
    notifyListeners();
    print(data);
  }
}

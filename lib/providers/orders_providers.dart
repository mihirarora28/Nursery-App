import 'package:flutter/material.dart';

import 'cart_provider.dart';

class OrderItem{
  final String id;
  final double totalAmount;
  final DateTime dateTime;
  final List<Cart> products;
  OrderItem({
    required this.dateTime,
    required this.id,
    required this.products,
    required this.totalAmount});
}

class OrdersProvider with ChangeNotifier{
  List<OrderItem> _items = [];
  List<OrderItem> get items{
    return [..._items];
  }
  void addItem(String id, double totalAmount, List<Cart> products){
    _items.add(OrderItem(dateTime: DateTime.now(), id: id, products: products, totalAmount: totalAmount));
    // print(_items.length);
    notifyListeners();
  }
  void removeAll(){
    _items = [];
    notifyListeners();
  }
}
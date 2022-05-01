import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  String imageUrl;
  double price;
  bool isFavorites;

  Product({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.title,
    this.isFavorites = false,
  });
  void toggle() {
    isFavorites = !isFavorites;
    notifyListeners();
  }
}

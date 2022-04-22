import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorites = false;

  Product(
      {required this.id,
      required this.description,
      required this.imageUrl,
       required this.price,
      required this.title,
      });
  void toggle(){
    isFavorites = !isFavorites;
    notifyListeners();
  }
}
import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier{
   String id;
   String title;
   String description;
   String imageUrl;
   double price;
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
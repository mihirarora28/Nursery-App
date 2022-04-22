import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cart{
  String id;
  String title;
  double price;
  int quantity;
  Cart({
    required this.title,
    required this.id,
    required this.price,
    required this.quantity});
}

class CartProvider with ChangeNotifier{
  Map<String,Cart> _cartitems ={};
  Map<String,Cart> get items{
    return {..._cartitems};
  }
    int sizeOfMap = 0;
  double totalamount = 0.0;
  void addItem(String id, String title, double price){

    if(_cartitems.containsKey(id)){
      int quantity = _cartitems[id]!.quantity;
      _cartitems.removeWhere((key, value) => key == id);
      _cartitems[id] = Cart(title: title, id: id, price: price, quantity: quantity + 1);
    }
    else{
      _cartitems[id] = Cart(title: title, id:id, price: price, quantity: 1);
    }

    sizeOfMap = _cartitems.length;
    notifyListeners();
  }
  void removeItem(String id){
            _cartitems.removeWhere((key, value) => value.id == id);
            sizeOfMap = _cartitems.length;
            calculate();
            notifyListeners();

  }
  void leftSwipe(String id){
    int quantity = _cartitems[id]!.quantity;
    if(quantity > 1){
      _cartitems.update(id, (value){
        return Cart(id: value.id, title: value.title, price: value.price,quantity: value.quantity - 1);
      });
    }
    else{
      _cartitems.removeWhere((key, value) => value.id == id);

    }
    sizeOfMap = _cartitems.length;
    calculate();
    notifyListeners();
  }

  void calculate(){
    totalamount = 0;
    _cartitems.forEach((key, value) {
      totalamount+= value.price*value.quantity;
    });
    notifyListeners();
  }
  void cartREmoveAll() {
    _cartitems = {};
    sizeOfMap = _cartitems.length;
    calculate();
    notifyListeners();
  }

}
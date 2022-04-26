import 'package:flutter/material.dart';
import 'package:shops/models/product.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';
class Products with ChangeNotifier{
   List<Product> _items =[];

   var showfavourites = false;

   void ShowFavorites(){
     showfavourites = true;
     notifyListeners();
   }
   void ShowAll(){
     showfavourites = false;
     notifyListeners();
   }
   List<Product> get products{
    return [..._items];
   }
   Future<void> delete(String id)async{
     var url = 'https://shopapp2-1c326-default-rtdb.firebaseio.com/products/$id.json';
     try {
       await https.delete(Uri.parse(url));
       _items.removeWhere((element) => element.id == id);
       notifyListeners();
     }
     catch(error){
       print(error.toString());
     }
   }
   Future<void> UpdateProduct(String id,String title,String description,double price,String Url) async{

     var url = 'https://shopapp2-1c326-default-rtdb.firebaseio.com/products/$id.json';
   await https.patch(Uri.parse(url),body: json.encode(
       {
         'description':description,
         'imageUrl':Url,
         'price':price,
         'title':title,
       }
     ));


     _items.forEach((element) {
       if (element.id == id) {
         element.id = id;
         element.title = title;
         element.description = description;
         element.price = price;
         element.imageUrl = Url;
       }
     });
         notifyListeners();
   }
   Future<void> fetchData() async {
     List<Product> _its = [];
     var url = 'https://shopapp2-1c326-default-rtdb.firebaseio.com/products.json';
     try {
      final response =  await https.get(Uri.parse(url));

       final extracted = (json.decode(response.body)) as Map<String,dynamic>;
       // print(extracted);
      extracted.forEach((key, value) {
        _its.add(Product(id: key,title:value['title'],description: value['description'],
        price: value['price'],imageUrl: value['imageUrl'],isFavorites:  value['favourites'] ));
      });
      _items = _its;
      notifyListeners();

     }
     catch(error){
       print(error.toString());
       // throw(error);
     }
   }
   Future<void> updateFavourites(String id, bool ans) async {
     var url = 'https://shopapp2-1c326-default-rtdb.firebaseio.com/products/$id.json';
     try{
       final response = await https.patch(Uri.parse(url),body: json.encode({
         'favourites' : ans

       })).then((value) {
         _items.forEach((element) {
           if (element.id == id) {
             element.id = id;
             element.isFavorites = ans;
           }
         });
         notifyListeners();
       });
     }
     catch(error){
       print(error.toString());
       throw(error);
     }
   }
   Future<void> addProduct(String id,String title,String description,double price,String Url) async {
     var url = 'https://shopapp2-1c326-default-rtdb.firebaseio.com/products.json';
     var URL = Uri.parse(url);
     try {
       final response = await https.post(URL, body: json.encode({
         // 'id' : id,
         'title': title,
         'description': description,
         'price': price,
         'imageUrl': Url,
         'favourites':false,
       }));
       _items.add(
           Product(id: json.decode(response.body)['name'],
               // getting the id;
               title: title,
               description: description,
               price: price,
               isFavorites: false,
               imageUrl: Url));
       notifyListeners();
     }
     catch (error) {
       print(error.toString());
       throw error;
     }
     // print();

     // print( json.decode(response.body)['name']);
     // app wont crash because we tell dart we handled the error

     // print(error.toString());
   }
   }
import 'package:flutter/material.dart';
import 'package:shops/models/product.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [];

  var showfavourites = false;

  void ShowFavorites() {
    showfavourites = true;
    notifyListeners();
  }

  void ShowAll() {
    showfavourites = false;
    notifyListeners();
  }

  List<Product> get products {
    return [..._items];
  }

  final mytoken;
  final _UserId;

  Future<void> delete(String id) async {
    var url =
        'https://shopapp2-1c326-default-rtdb.firebaseio.com/products/$id.json?auth=$mytoken';
    print(id);
    var url2 =
        'https://shopapp2-1c326-default-rtdb.firebaseio.com/userFavourites/$_UserId/$id.json?auth=$mytoken';
    try {
      await https.delete(Uri.parse(url));
      print("43");
      _items.removeWhere((element) => element.id == id);
      //////////
      await https.delete(Uri.parse(url2));

      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> UpdateProduct(String id, String title, String description,
      double price, String Url) async {
    var url =
        'https://shopapp2-1c326-default-rtdb.firebaseio.com/products/$id.json?auth=$mytoken';
    await https.patch(Uri.parse(url),
        body: json.encode({
          'description': description,
          'imageUrl': Url,
          'price': price,
          'title': title,
        }));

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

  Products(this.mytoken, this._items, this._UserId);

  Future<void> fetchData() async {
    List<Product> _its = [];
    final url =
        'https://shopapp2-1c326-default-rtdb.firebaseio.com/products.json?auth=$mytoken';
    ////////////////////////////////////////////////////////////////////////////////
    final url2 =
        'https://shopapp2-1c326-default-rtdb.firebaseio.com/userFavourites/$_UserId.json?auth=$mytoken';

    try {
      final response = await https.get(Uri.parse(url));

      if ((json.decode(response.body)) == null) {
        print("42");
        _items = [];
        notifyListeners();
        return;
      }
      final extracted = (json.decode(response.body)) as Map<String, dynamic>;


      final response2 = await https.get(Uri.parse(url2));


      var extracted2 = null;


      if ((json.decode(response2.body)) != null)
        extracted2 = (json.decode(response2.body)) as Map<String, dynamic>;


      extracted.forEach((key, value) {

        if (value['userId'] == _UserId) {
          _its.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorites: extracted2 == null ? false :(extracted2[key] == null ? false: extracted2[key]['fav']),
          ));
        }
        // isFavorites: value['favourites']));
      });
      print(_its.length);
      // print(_its);
      // print('callllllllllllllllllllllllllllll');
      _items = _its;
      // print('callllllllllllllllllllllllllllll');
      // print("Calling...");
      // print(_items);


      notifyListeners();
    } catch (error) {
      print(error.toString());
      print("@#@#");
      // throw(error);
    }
  }

  Future<void> updateFavourites(String id, bool ans, String UserId) async {
    var url =
        'https://shopapp2-1c326-default-rtdb.firebaseio.com/userFavourites/$UserId/$id.json?auth=$mytoken';
    try {
      final response = await https
          .patch(Uri.parse(url), body: json.encode({'fav': ans}))
          .then((value) {
        _items.forEach((element) {
          if (element.id == id) {
            element.id = id;
            element.isFavorites = ans;
          }
        });
        notifyListeners();
      });
    } catch (error) {
      print(error.toString());
      // throw (error);
    }
  }

  Future<void> addProduct(String id, String title, String description,
      double price, String Url) async {
    var url =
        'https://shopapp2-1c326-default-rtdb.firebaseio.com/products.json?auth=$mytoken';
    var URL = Uri.parse(url);
    try {
      final response = await https.post(URL,
          body: json.encode({
            'id': id,
            'title': title,
            'description': description,
            'price': price,
            'imageUrl': Url,
            'userId': _UserId,
            // 'favourites': false,
          }));
      _items.add(Product(
          id: json.decode(response.body)['name'],
          // getting the id;
          title: title,
          description: description,
          price: price,
          isFavorites: false,
          imageUrl: Url));
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
    // print();

    // print( json.decode(response.body)['name']);
    // app wont crash because we tell dart we handled the error

    // print(error.toString());
  }
}

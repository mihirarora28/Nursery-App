import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:http/http.dart' as https;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shops/models/httpexception.dart';

class AuthProvider with ChangeNotifier {
  var _token;
  var _expiryDate;
  var _userId;

  String get token {
    if (_token != null)
      return _token;
    else
      return "";
  }

  String get userId {
    if (_userId != null)
      return _userId;
    else
      return "";
  }

  bool get isAuthenticated {
    print(_token);
    print(_expiryDate);

    print(_userId);

    if (_token != null &&
        _userId != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }

  final urlLogin =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyABNfp75ZkF-dr_PrSC_Astzoi6Lt7L0ok';
  final urlRegister =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyABNfp75ZkF-dr_PrSC_Astzoi6Lt7L0ok';

  Future<void> login(String email, String password, bool test) async {
    var response = await https.post(Uri.parse(urlLogin),
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': test}));
    final val = json.decode(response.body);
    // print(val['error']);
    if (val['error'] != null) {
      // print("#2");
      throw HttpException(val['error']['message']);
    }
    print(val);
    _token = val['idToken'];
    _expiryDate =
        DateTime.now().add(Duration(seconds: int.parse(val['expiresIn'])));
    _userId = val['localId'];
    autologout();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'expiryDate': (_expiryDate as DateTime).toIso8601String(),
      'userId': _userId,
    });
    prefs.setString('userData', userData);
  }

  Future<void> signUp(String email, String password, bool test) async {
    var response = await https.post(Uri.parse(urlRegister),
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': test}));
    final val = json.decode(response.body);

    if (val['error'] != null) {
      throw HttpException(val['error']['message']);
    }
    _token = val['idToken'];
    _expiryDate =
        DateTime.now().add(Duration(seconds: int.parse(val['expiresIn'])));

    _userId = val['localId'];
    autologout();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'expiryDate': (_expiryDate as DateTime).toIso8601String(),
      'userId': _userId,
    });
    prefs.setString('userData', userData);
  }

  Future<bool> tryLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData') == false) {
      return false;
    }
    final data = json.decode(prefs.getString('userData') as String)
        as Map<String, dynamic>;
    final expdate = DateTime.parse(data['expiryDate']);
    if (expdate.isBefore(DateTime.now())) {
      return false;
    }
    _token = data['token'];
    _userId = data['userId'];
    _expiryDate = expdate;
    notifyListeners();
    autologout();
    return true;
  }

  Future<void> logout() async {
    _expiryDate = null;
    _token = null;
    _userId = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void autologout() {
    final timeLeftinseconds =
        (_expiryDate as DateTime).difference(DateTime.now()).inSeconds;
    final myTimer = Timer(Duration(seconds: timeLeftinseconds), () {
      logout();
    });
  }
}

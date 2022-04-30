import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';

import 'package:shops/models/httpexception.dart';

class Auth with ChangeNotifier {
  String token;
  DateTime expiryDate;
  String userId;

  Auth({required this.expiryDate, required this.token, required this.userId});
}

class AuthProvider with ChangeNotifier {
  final urlLogin =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyABNfp75ZkF-dr_PrSC_Astzoi6Lt7L0ok';
  final urlRegister =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyABNfp75ZkF-dr_PrSC_Astzoi6Lt7L0ok';

  Future<void> login(String email, String password, bool test) async {
    var response = await https.post(Uri.parse(urlLogin),
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': test}));
    final val = json.decode(response.body);
    print(val['error']);
    if (val['error'] != null) {
      // print("#2");

      throw HttpException(val['error']['message']);
    }
  }

  Future<void> signUp(String email, String password, bool test) async {
    var response = await https.post(Uri.parse(urlRegister),
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': test}));
    final val = json.decode(response.body);
    // print(val);
    if (val['error'] != null) {
      throw HttpException(val['error']['message']);
    }
  }
}

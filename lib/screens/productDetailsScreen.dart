import 'package:flutter/material.dart ';
class ProductDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(arguments.toString()),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
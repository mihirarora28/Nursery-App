import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart ';
class ProductDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(arguments['title'].toString()),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
        Image.network(arguments['images'], height: 400,width: 400,),
          SizedBox(height: 20,),
          Text(arguments['title'],style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
          Padding(padding: EdgeInsets.all((10.0)), child: Text(arguments['description'],style: TextStyle(fontSize: 20)),
          )],
      ),
    );
  }
}
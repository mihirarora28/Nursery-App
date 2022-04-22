import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops/providers/orders_providers.dart';
import 'package:intl/intl.dart';
import 'package:shops/widgets/order_item.dart';
class orders_screen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final myList = Provider.of<OrdersProvider>(context,listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Shopping App'),
      ),
      body: Container(
        height: double.infinity,
        child: ListView.builder(
          itemCount: myList.items.length,
            itemBuilder: (ctx,index){
            return OrderItemHa(
                dateTime:DateFormat.yMMMMEEEEd().format(DateTime.now()).toString() ,
                id: myList.items[index].id.toString(),
                products:  myList.items[index].products,
                totalAmount: myList.items[index].totalAmount.toString());
          // return Text(myList.items[index].totalAmount.toString());
        }),
      ),
    );
  }
}

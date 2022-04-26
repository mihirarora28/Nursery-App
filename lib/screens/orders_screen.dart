import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops/providers/orders_providers.dart';
import 'package:intl/intl.dart';
import 'package:shops/widgets/order_item.dart';
class orders_screen extends StatefulWidget {

  @override
  State<orders_screen> createState() => _orders_screenState();
}

class _orders_screenState extends State<orders_screen> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<OrdersProvider>(context,listen: false).fetchMyOrders().then((value){
      print("HHELO");
    });
    super.initState();
  }
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
                dateTime:DateFormat.yMEd().add_jms().format(myList.items[index].dateTime).toString(),
                id: myList.items[index].id.toString(),
                products:  myList.items[index].products.toList(),
                totalAmount: myList.items[index].totalAmount.toStringAsFixed(2));
          // return Text(myList.items[index].totalAmount.toString());
        }),
      ),
    );
  }
}

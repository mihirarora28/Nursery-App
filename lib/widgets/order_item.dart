import 'package:flutter/material.dart';
import 'package:shops/providers/cart_provider.dart';
class OrderItemHa extends StatefulWidget {
  final String id;
  final String dateTime;
  final String totalAmount;
  final List<Cart> products;

  OrderItemHa({
    required this.products,
    required this.id,
    required this.totalAmount,
    required this.dateTime,
  });

  @override
  State<OrderItemHa> createState() => _OrderItemHaState();
}

class _OrderItemHaState extends State<OrderItemHa> {
  var expanded = false;

  @override
  Widget build(BuildContext context) {
   return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
      child: Column(
        children:[ ListTile(
          title: Text(widget.totalAmount),
          subtitle: Text(widget.dateTime),
          trailing: IconButton(icon: Icon(expanded == true ?Icons.arrow_upward_rounded :Icons.arrow_downward_rounded  ), onPressed: (){
            setState(() {
              expanded = !expanded;
            });

          },),
        ),
          Divider(),
         expanded == true ? Container(
            // margin: EdgeInsets.symmetric(horizontal: 5.0),
            height: 100,
            child: ListView.builder(
              itemCount: widget.products.length,
                itemBuilder: (ctx,index){
              return ListTile(
                title: Text( widget.products[index].title),
                trailing: Text('X' + widget.products[index].quantity.toString()),
              );
            }),
          ):Container(height: 0,)
    ]
      ),
    );
  }
}

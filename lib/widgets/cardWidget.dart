import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops/providers/cart_provider.dart';
class cartWidget extends StatelessWidget {
  final int quantity;
  final String title;
  final String amount;
  final String id;
  cartWidget({
   required this.amount,
    required this.id,
    required this.quantity,
    required this.title});
  @override
  Widget build(BuildContext context) {
    final myList = Provider.of<CartProvider>(context,listen: false);
    return Dismissible(
      // direction: DismissDirection.endToStart,
      onDismissed: (direction){
        if(direction == DismissDirection.startToEnd){
          // myList.removeItem(id);
          myList.leftSwipe(id);
        }
        else {
          myList.removeItem(id);
         }
      },
      background: Container(
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete,color: Colors.white,),
        padding: EdgeInsets.all(10.0),
        color: Theme.of(context).errorColor,),
      key: UniqueKey(),
      child: Card(
        margin: EdgeInsets.all(5.0),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: EdgeInsets.all(5.0),
                child: FittedBox(child: Text(amount.toString()))),
          ),
          title: Text(title.toString()),
          subtitle: Text(amount.toString()),
          trailing: Text('X' + quantity.toString()),
        ),
      ),
    );
  }
}

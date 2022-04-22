import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops/providers/cart_provider.dart';
import 'package:shops/providers/orders_providers.dart';
import 'package:shops/widgets/cardWidget.dart';
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myList = Provider.of<CartProvider>(context,listen: true);
    final myList2 = Provider.of<OrdersProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Cart Screen"),
      ),
      body:Column(
        children:[ Card(
          margin: EdgeInsets.all(20.0),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                  SizedBox(width: 20.0,),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(myList.totalamount.toStringAsFixed(2),style: TextStyle(fontSize: 15.0,color: Colors.white),),
                  ),
                   FlatButton(
                    child: Text('ORDER NOW',style: TextStyle(color: Theme.of(context).primaryColor),),onPressed: (){
                      if(myList.sizeOfMap == 0){
                        return;
                      }
                     myList2.addItem(DateTime.now().toString(), myList.totalamount, myList.items.values.toList());
                     myList.cartREmoveAll();
                   },)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
         Expanded(
             child: myList.sizeOfMap  == 0 ?  Center(child: Text('No Items on Screen',style: TextStyle(fontSize:20.0,color: Theme.of(context).primaryColor ),),):ListView.builder(
               itemCount: myList.sizeOfMap,
                 itemBuilder: (ctx,index){
                 return cartWidget(
                   id: myList.items.values.toList()[index].id.toString(),
                 amount: (myList.items.values.toList()[index].quantity*myList.items.values.toList()[index].price).toStringAsFixed(2),
                 quantity: myList.items.values.toList()[index].quantity,
                 title:  myList.items.values.toList()[index].title.toString(),
                 );
             }),
           ),
        ]
      ),
      
    );
  }
}

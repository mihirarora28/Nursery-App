import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops/providers/providers_list.dart';
import 'package:shops/screens/editProduct.dart';
class newProductWidget extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
   final String description;
    final double price;
  newProductWidget({
    required this.id,
  required  this.title,
   required  this.imageUrl,
required this.description,
   required this.price,
  });
  @override
  Widget build(BuildContext context) {
    final list = Provider.of<Products>(context,listen:  true);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title.toString()),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(onPressed: (){
             Navigator.of(context).pushNamed('/EditProductsScreen',arguments: {
               'id' : id,
               'imageUrl':imageUrl,
               'price':price,
               'description':description,
               'title':title,
                'edited':true,
             });
              }, icon: Icon(Icons.edit,color: Colors.indigo,)),
              IconButton(onPressed: (){
                showDialog(context: context, builder: (ctx){
                  return AlertDialog(
                    title: Text('Warning!',style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                    content: Text('Are you sure you want to delete the product ?'),actions: [
                    FlatButton(onPressed: (){Navigator.of(context).pop(false);},child: Text('NO',style: TextStyle(color:Theme.of(context).primaryColor),),),
                    FlatButton(onPressed: (){Navigator.of(context).pop(true);},child: Text('YES',style: TextStyle(color:Theme.of(context).primaryColor),),)
                  ],);
                }).then((value){
                  if(value == true){
                    list.delete(id);
                  }
                  else{
                    return;
                  }
                });
               }, icon: Icon(Icons.delete,color: Theme.of(context).errorColor,)),
            ],
          ),
        ),
      ),
    );

  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops/models/product.dart';
import 'package:shops/providers/cart_provider.dart';
import 'package:shops/providers/providers_list.dart';
class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String ImageURL;
  final double price;
  ProductItem({
   required this.title,
   required this.description,
  required  this.id,
   required this.ImageURL,
  required  this.price,
  });
  @override
  Widget build(BuildContext context) {
    final myList = Provider.of<Products>(context,listen: false);
    final myList2 = Provider.of<CartProvider>(context,listen: false);
    Provider.of<Product>(context,listen: true);
    Product prod = myList.items.firstWhere((element) => element.id == id);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: GridTile(
        child: GestureDetector(
          onTap: (){Navigator.pushNamed(context, '/ProductDetailsScreen',arguments: id);},
            child: Image.network(ImageURL,fit: BoxFit.cover,)),
        footer: GridTileBar(
          leading: IconButton(
            iconSize: 25.0,
              icon:prod.isFavorites == true?Icon(Icons.favorite):Icon(Icons.favorite_outline),onPressed: (){
              prod.toggle();
          },color: Theme.of(context).primaryColor),
          backgroundColor: Colors.black.withOpacity(0.7),
          trailing: IconButton(
            iconSize: 25.0,
            icon: Icon(Icons.shopping_cart),onPressed: (){

            myList2.addItem(id, title, price);
            myList2.calculate();
            // myList2.items.forEach((key, value) {
            //   // print(key);
            //   // print(value);
            // });
          },color: Theme.of(context).primaryColor,),
          title: Center(child: Text(title.toString(),style: TextStyle(fontWeight: FontWeight.bold),)),
        ),
      ),
    );
  }
}

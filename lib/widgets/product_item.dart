import 'package:flutter/material.dart';
class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String ImageURL;
  ProductItem({
   required this.title,
   required this.description,
  required  this.id,
   required this.ImageURL});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: GridTile(
        child: GestureDetector(
          onTap: (){Navigator.pushNamed(context, '/ProductDetailsScreen',arguments: id);},
            child: Image.network(ImageURL,fit: BoxFit.cover,)),
        footer: GridTileBar(
          leading: IconButton(
            iconSize: 25.0,
              icon: Icon(Icons.favorite_border),onPressed: (){},color: Theme.of(context).primaryColor),
          backgroundColor: Colors.black.withOpacity(0.7),
          trailing: IconButton(
            iconSize: 25.0,
            icon: Icon(Icons.shopping_cart),onPressed: (){},color: Theme.of(context).primaryColor,),
          title: Center(child: Text(title.toString(),style: TextStyle(fontWeight: FontWeight.bold),)),
        ),
      ),
    );
  }
}

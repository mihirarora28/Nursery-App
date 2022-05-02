import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops/models/product.dart';
import 'package:shops/providers/auth.dart';
import 'package:shops/providers/cart_provider.dart';
import 'package:shops/providers/providers_list.dart';

class ProductItem extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String ImageURL;
  final double price;
  final bool favourites;

  ProductItem(
      {required this.title,
      required this.description,
      required this.id,
      required this.ImageURL,
      required this.price,
      required this.favourites});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final myList = Provider.of<Products>(context, listen: false);
    final myList2 = Provider.of<CartProvider>(context, listen: false);
    final myList3 = Provider.of<AuthProvider>(context, listen: false);

    Provider.of<Product>(context, listen: true);
    Product prod =
        myList.products.firstWhere((element) => element.id == widget.id);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/ProductDetailsScreen', arguments: {
                'images': widget.ImageURL,
                'title': widget.title,
                'price': widget.price,
                'description': widget.description,
              });
            },
            child: Image.network(
              widget.ImageURL,
              fit: BoxFit.cover,
            )),
        footer: GridTileBar(
          leading: IconButton(
              iconSize: 25.0,
              icon: isLoading == false
                  ? (widget.favourites == true
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_outline))
                  : CircularProgressIndicator(),
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                myList
                    .updateFavourites(
                        widget.id, !widget.favourites, myList3.userId)
                    .then((value) {
                  setState(() {
                    isLoading = false;
                  });
                });
              },
              color: Theme.of(context).primaryColor),
          backgroundColor: Colors.black.withOpacity(0.7),
          trailing: IconButton(
            iconSize: 25.0,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 2),
                content: Text('Added to the cart!'),
                backgroundColor: Theme.of(context).primaryColor,
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    myList2.undoCart(widget.id);
                  },
                  textColor: Colors.white,
                ),
              ));

              myList2.addItem(widget.id, widget.title, widget.price);
              myList2.calculate();
              // myList2.items.forEach((key, value) {
              //   // print(key);
              //   // print(value);
              // });
            },
            color: Theme.of(context).primaryColor,
          ),
          title: Center(
              child: Text(
            widget.title.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}

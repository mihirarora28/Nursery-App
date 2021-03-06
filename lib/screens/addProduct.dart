import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops/models/product.dart';
import 'package:shops/providers/providers_list.dart';
import 'package:shops/widgets/newProduct.dart';

class AddProduct extends StatelessWidget {
  Future<void> onrefresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<Products>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Plant App'),
        actions: [
          Padding(
              padding: EdgeInsets.all(10.0),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed('/EditProductsScreen');
                },
              )),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => onrefresh(context),
        child: ListView.builder(
            itemCount: list.products.length,
            itemBuilder: (ctx, index) {
              return newProductWidget(
                imageUrl: list.products[index].imageUrl,
                title: list.products[index].title,
                id: list.products[index].id,
                description: list.products[index].description,
                price: list.products[index].price,
              );
            }),
      ),
    );
  }
}

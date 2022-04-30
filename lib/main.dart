import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops/providers/auth.dart';
import 'package:shops/providers/cart_provider.dart';
import 'package:shops/providers/orders_providers.dart';
import 'package:shops/providers/providers_list.dart';
import 'package:shops/screens/addProduct.dart';
import 'package:shops/screens/auth_screen.dart';
import 'package:shops/screens/cart_screen.dart';
import 'package:shops/screens/editProduct.dart';
import 'package:shops/screens/orders_screen.dart';
import 'package:shops/screens/productDetailsScreen.dart';
import 'package:shops/widgets/badge.dart';
import 'package:shops/widgets/product_item.dart';
import 'models/product.dart';

void main() {
  runApp(MyApp());
}

enum FilterOptions { onlyFavourites, ShowmeAll }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    // final response = Provider.of<AuthProvider>(context, listen: false);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => CartProvider()),
          ChangeNotifierProvider(create: (ctx) => OrdersProvider()),
          ChangeNotifierProvider(create: (ctx) => AuthProvider()),
          ChangeNotifierProvider(create: (ctx) => Products()),
          // ChangeNotifierProxyProvider<AuthProvider, Products>(
          //     // create: Products(),
          //     builder: (ctx, Auth, previousProd) => Products(Auth.token,
          //         previousProd == null ? [] : previousProd.products)),
        ],
        // value: Products()
        child: Consumer<AuthProvider>(
          builder: (ctx2, Auth, _) => MaterialApp(
            routes: {
              '/ProductDetailsScreen': (ctx) => ProductDetailsScreen(),
              '/cartScreen': (ctx) => CartScreen(),
              '/OrdersScreen': (ctx) => orders_screen(),
              '/addProductScreen': (ctx) => AddProduct(),
              '/EditProductsScreen': (ctx) => EditProductsScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
            },
            home: Auth.isAuthenticated == true ? MyHomePage() : AuthScreen(),
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
            ),
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    // TODO: implement initState
    Provider.of<Products>(context, listen: false).fetchData().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  Future<void> onrefresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final myList = Provider.of<Products>(context, listen: true);
    final myList2 = Provider.of<CartProvider>(context, listen: true);
    List<Product> newList = myList.products;
    if (myList.showfavourites == true) {
      newList =
          newList.where((element) => element.isFavorites == true).toList();
    }
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text('Shopping App'),
              automaticallyImplyLeading: false,
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              leading: Icon(Icons.production_quantity_limits),
              title: Text('Your Products'),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/cartScreen');
              },
              leading: Icon(Icons.shopping_cart),
              title: Text('Your Cart'),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/OrdersScreen');
              },
              leading: Icon(Icons.payments_rounded),
              title: Text('Your Orders Screen'),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/addProductScreen');
              },
              leading: Icon(Icons.add),
              title: Text('Add/Edit/Delete Product'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cartScreen');
            },
            icon: Badge(
                child: Icon(
                  Icons.shopping_cart,
                  size: 30.0,
                ),
                color: Theme.of(context).primaryColor,
                value: myList2.sizeOfMap.toString()),
          ),
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOptions index) {
                print(index);
                if (index == FilterOptions.onlyFavourites) {
                  myList.ShowFavorites();
                } else {
                  myList.ShowAll();
                }
              },
              itemBuilder: (_) {
                return [
                  PopupMenuItem(
                    child: Text("Favourite Products"),
                    value: FilterOptions.onlyFavourites,
                  ),
                  PopupMenuItem(
                    child: Text("Show All Products"),
                    value: FilterOptions.ShowmeAll,
                  ),
                ];
              }),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Shopping App'),
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => onrefresh(context),
              child: GridView.builder(
                padding: EdgeInsets.all(20.0),
                itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                  value: newList[index],
                  child: ProductItem(
                    id: newList[index].id,
                    description: newList[index].description,
                    title: newList[index].title,
                    ImageURL: newList[index].imageUrl,
                    price: newList[index].price,
                    favourites: newList[index].isFavorites,
                  ),
                ),
                itemCount: newList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
              ),
            ),
    );
  }
}

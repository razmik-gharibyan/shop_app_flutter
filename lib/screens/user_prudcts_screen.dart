import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";

  @override
  Widget build(BuildContext context) {

    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator(),) : RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: Consumer(
              builder: (ctx, productsData, child) => Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemBuilder: (ctx, index) => Column(
                    children: [
                      UserProductItem(
                          productsData.items[index].id,
                          productsData.items[index].title,
                          productsData.items[index].imageUrl
                      ),
                      Divider(),
                    ],
                  ),
                  itemCount: productsData.items.length,
                ),
              ),
            ),
        ),
      ),
    );
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }
}

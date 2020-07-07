import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {

  final bool showOnlyFavorites;

  ProductsGrid(this.showOnlyFavorites) {}

  @override
  Widget build(BuildContext context) {

    final productsData = Provider.of<Products>(context);
    final products = showOnlyFavorites ? productsData.favoriteItems : productsData.items;

    

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(
            //products[index].id,
            //products[index].title,
            //products[index].imageUrl
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,childAspectRatio: 3/2,crossAxisSpacing: 10,mainAxisSpacing: 10
      ),
    );
  }
}
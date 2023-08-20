import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //--------------------------------------------------
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    //--------------------------------------------------
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider( //---------------
        create: (c) => products[index],
        child: ProductItem(
          // id: products[index].id,
          // title: products[index].title,
          // price: products[index].price,
          // imageUrl: products[index].imageUrl,
        ),
      ),
    );
  }
}
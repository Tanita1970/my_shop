import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final double price;
  // final String imageUrl;
  //
  // ProductItem({
  //   required this.id,
  //   required this.title,
  //   required this.price,
  //   required this.imageUrl,
  // });

  @override
  Widget build(BuildContext context) {
    //---------------------------------------------------------------
    final product = Provider.of<Product>(context);
    //---------------------------------------------------------------
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            icon: Icon( //---------------------------------------------
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              product.toggleFavoriteStatus(); //----------------------
            },
          ),
          title: Text(
            product.title, //-----------------------------------------
            textAlign: TextAlign.center,
          ),
          subtitle: Text('\$${product.price}'),
          //---------------------
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {},
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id, //--------------------------------
            );
          },
          child: Image.network(
            product.imageUrl, //------------------------------------
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

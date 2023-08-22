import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/product.dart';
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
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    //---------------------------------------------------------------
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            icon: Consumer<Product>(
              builder: (context, product, child) => Icon(
                //---------------------------------------------
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              product.toggleFavoriteStatus();
              print(product.isFavorite);
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
            onPressed: () {
              cart.addItem(
                product.id,
                product.price,
                product.title,
              );
              print(product.title);
              print(cart.items[product.id]?.quantity);
              print(cart.items);
            },
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

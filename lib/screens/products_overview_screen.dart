import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  //---------------------------------------------------
  var _showOnlyFavorites = false;

  //--------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // final productContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                  // productContainer.showFavoritesOnly();
                } else {
                  _showOnlyFavorites = false;
                  // productContainer.showAll();
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: FilterOptions.Favorites,
                  child: Text('Only Favorites')),
              const PopupMenuItem(
                  value: FilterOptions.All, child: Text('Show All')),
            ],
          )
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}

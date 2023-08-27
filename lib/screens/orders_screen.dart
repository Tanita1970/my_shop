import 'package:flutter/material.dart';
import 'package:my_shop/providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import 'package:my_shop/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Orders',
        ),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (context, index) => OrderItem(
            orderData.orders[index],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart_screen";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your cart"),
      ),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(children: [
              Text(
                  "Total",
                  style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              Chip(
                label: Text("\$${cart.totalSum.toStringAsFixed(2)}",style: TextStyle(color: Theme.of(context).primaryColorLight),),
                backgroundColor: Theme.of(context).primaryColor,),
              FlatButton(
                child: Text("Proceed to payment", style: TextStyle(color: Theme.of(context).primaryColor),),
                onPressed: () {
                  Provider.of<Orders>(context,listen: false).addOrder(cart.items.values.toList(), cart.totalSum);
                  cart.clearCart();
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,),
          ),
        ),
        SizedBox(height: 10,),
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx,index) => CartItem(
              cart.items.values.toList()[index].id,
              cart.items.keys.toList()[index],
              cart.items.values.toList()[index].price,
              cart.items.values.toList()[index].quantity,
              cart.items.values.toList()[index].title,
            ),
            itemCount: cart.itemCount,
          ),
        )
      ],),
    );
  }
}

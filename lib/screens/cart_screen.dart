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
              OrderButton(cart: cart)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ?
      Center(child: CircularProgressIndicator(),) :
      Text("Proceed to payment", style: TextStyle(color: Theme.of(context).primaryColor),),
      onPressed: (widget.cart.totalSum <= 0 || _isLoading) ? null : () async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context,listen: false).addOrder(widget.cart.items.values.toList(), widget.cart.totalSum);
        setState(() {
          _isLoading = false;
        });
        widget.cart.clearCart();
      },
    );
  }
}

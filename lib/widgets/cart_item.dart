import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantitiy;
  final String title;

  CartItem(this.id,this.productId,this.price,this.quantitiy,this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context,listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(context: context, builder: (ctx) => AlertDialog(
          title: Text("Are you sure?"),
          content: Text("Do you want to remove the item from the cart"),
          actions: [
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        ));
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 40),
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                    child: Text("\$${price}"),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text("total \$ ${price * quantitiy}"),
            trailing: Text("$quantitiy x"),
          ),
        ),
      ),
    );
  }
}

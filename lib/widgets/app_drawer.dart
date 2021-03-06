import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_prudcts_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text("Hello friend"),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text("Shop"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed("/"); // Go to home page
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text("Orders"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName); // Go to home page
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("Manage products"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName); // Go to home page
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Log out"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed("/");
            Provider.of<Auth>(context, listen: false).logOut(); // Go to home page
          },
        ),
      ],),
    );
  }
}

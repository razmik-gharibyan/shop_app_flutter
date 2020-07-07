import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final Order orderItem;

  OrderItem(this.orderItem) {}

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text("\$${widget.orderItem.amount}"),
          subtitle: Text(DateFormat("dd/ mm/ yyyy/ hh:mm").format(widget.orderItem.dateTime)),
          trailing: IconButton(
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
        ),
        if(_expanded) Container(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
          height: min(widget.orderItem.products.length * 20.0 + 10, 100), // Adds container with first value of min() method, if -
          // - first value is too high then chose second value in our case 180
          child: ListView.builder(
              itemBuilder: (ctx, index) => Row(children: [
                Text(
                    widget.orderItem.products[index].title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Text(
                    "${widget.orderItem.products[index].quantity}x \$${widget.orderItem.products[index].price}",
                    style: TextStyle(fontSize: 18,color: Colors.grey),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,),
              itemCount: widget.orderItem.products.length,),
        )
      ],),
    );
  }
}

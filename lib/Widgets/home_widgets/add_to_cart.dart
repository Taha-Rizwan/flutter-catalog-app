import 'package:depression/core/store.dart';
import 'package:depression/models/cart.dart';
import 'package:depression/models/catalog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AddToCart extends StatelessWidget {
  final Item catalog;

  AddToCart({Key? key, required this.catalog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [AddMutation, RemoveMutation]);
    final CartModel _cart = (VxState.store as MyStore).cart;

    bool isInCart = _cart.items.contains(catalog);
    return FloatingActionButton(
      onPressed: () {
        if (!isInCart) {
          AddMutation(catalog);
        }
      },
      backgroundColor: context.theme.buttonColor,
      child: isInCart
          ? Icon(
              Icons.done,
              color: Colors.white,
            )
          : Icon(
              CupertinoIcons.cart_badge_plus,
              color: Colors.white,
            ).h8(context),
    );
  }
}

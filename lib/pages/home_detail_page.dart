import 'package:depression/core/store.dart';
import 'package:depression/models/cart.dart';
import 'package:depression/models/catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeDetailPage extends StatelessWidget {
  final Item catalog;

  const HomeDetailPage({Key? key, required this.catalog})
      : assert(catalog != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.3;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: context.canvasColor,
      bottomNavigationBar: Container(
        color: context.cardColor,
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          buttonPadding: EdgeInsets.zero,
          children: [
            "\$${catalog.price}"
                .text
                .bold
                .xl4
                .color(Vx.hexToColor(catalog.color))
                .make(),
            _addToShop(
              catalog: catalog,
            ).wh(120, 50),
          ],
        ).p32(),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Hero(
                    tag: Key(catalog.id.toString()),
                    child: Image.network(catalog.image))
                .centered()
                .h32(context),
            Expanded(
                child: VxArc(
              height: 30.0,
              arcType: VxArcType.CONVEY,
              edge: VxEdge.TOP,
              child: Container(
                color: context.cardColor,
                width: context.screenWidth,
                child: Column(
                  children: [
                    catalog.name.text.xl4
                        .color(Vx.hexToColor(catalog.color))
                        .bold
                        .make(),
                    catalog.desc.text.caption(context).xl.make(),
                    10.heightBox,
                    catalog.detail.text.caption(context).make().p16()
                  ],
                ).py64(),
              ),
            ).scrollVertical())
          ],
        ),
      ),
    );
  }
}

// ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, MyRoutes.cartRoute);
//               },
//               child: "Add to cart".text.make(),
//               style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.all(Vx.hexToColor(catalog.color)),
//                   shape: MaterialStateProperty.all(StadiumBorder())),
//             )
class _addToShop extends StatelessWidget {
  final Item catalog;
  _addToShop({Key? key, required this.catalog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [AddMutation, RemoveMutation]);
    final CartModel _cart = (VxState.store as MyStore).cart;
    bool isInCart = _cart.items.contains(catalog);
    return ElevatedButton(
      onPressed: () {
         if (!isInCart) {
          AddMutation(catalog);
        }
      },
      child: isInCart
          ? "Added!".text.makeCentered()
          : "Add to cart".text.makeCentered(),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Vx.hexToColor(catalog.color)),
          shape: MaterialStateProperty.all(StadiumBorder())),
    );
  }
}

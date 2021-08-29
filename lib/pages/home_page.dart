import 'package:depression/Widgets/home_widgets/catalogue_header.dart';
import 'package:depression/Widgets/home_widgets/catalogue_list.dart';
import 'package:depression/core/store.dart';
import 'package:depression/models/cart.dart';
import 'package:depression/models/catalog.dart';
import 'package:depression/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final url = "https://api.jsonbin.io/b/612b5c95c5159b35ae05ee7d/latest";
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    // final catalogJson =
    //     await rootBundle.loadString("assets/files/catalog.json");
    final response =
        await http.get(Uri.parse(url));
        final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    var productsData = decodedData["products"];
    CatalogModel.items =
        List.from(productsData).map((item) => Item.fromMap(item)).toList();
    setState(() {});
  }

  Widget build(BuildContext context) {
    final _cart = (VxState.store as MyStore).cart;
    return Scaffold(
      backgroundColor: context.canvasColor,
      floatingActionButton: VxBuilder(
        mutations: {AddMutation, RemoveMutation},
        builder: (context, status, _) => FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, MyRoutes.cartRoute);
          },
          backgroundColor: context.theme.buttonColor,
          child: Icon(
            CupertinoIcons.cart,
            color: Colors.white,
            ),
          ).badge(
            color: Vx.red500,
            size: 22,
            count: _cart.items.length,
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            )
          )
        ),
      body: SafeArea(
        child: Container(
          padding: Vx.m32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CatalogHeader(),
              if (CatalogModel.items != null && CatalogModel.items.isNotEmpty)
                CatalogList().py16().expand()
              else
                CircularProgressIndicator().centered().expand(),
            ],
          ),
        ),
      ),
    );
  }
}

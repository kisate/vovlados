import 'dart:typed_data';

import 'common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:convert';

class Cart {
  final items = Map<MenuItem, int>();
  int totalPrice = 0;
  int table;

  void updatePrice() {
    totalPrice = 0;
    items.forEach((item, count) {
      totalPrice += item.price * count;
    });
  }

  void clear() {
    totalPrice = 0;
    items.clear();
  }

  void addItem(MenuItem item) {
    if (items.containsKey(item) && items[item] < 9) {
      items[item]++;
    } else {
      items.putIfAbsent(item, () => 1);
    }
    updatePrice();
  }

  void removeItem(MenuItem item) {
    items[item]--;
    if (items[item] <= 0) {
      items.remove(item);
    }
    updatePrice();
  }

  Cart(this.table);

  @override
  String toString() {
    String itemsString =
        items.entries.map((e) => "${e.key.name}\t${e.value}").join("\n");
    return "$table\n$itemsString";
  }
}

class CartItemWidget extends StatelessWidget {
  final MenuItem item;
  final int count;
  final _CartPageState cartPageState;

  const CartItemWidget(
      {Key key,
      @required this.item,
      @required this.count,
      @required this.cartPageState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image(
                image: AssetImage(item.imageUrl),
              ),
            ),
            flex: 11,
          ),
          Spacer(flex: 1),
          Expanded(
            flex: 20,
            child: Container(
              width: 200,
              height: 100,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      item.shortName ?? item.name,
                      style: Theme.of(context)
                          .textTheme
                          .apply(
                              bodyColor: Colors.white,
                              displayColor: Colors.white)
                          .headline6,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            cartPageState.removeItem(item);
                          },
                          child: Text("-"),
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "$count",
                          style: Theme.of(context)
                              .textTheme
                              .apply(
                                  bodyColor: Colors.white,
                                  displayColor: Colors.white)
                              .headline6,
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              cartPageState.addItem(item);
                            },
                            child: Text("+")),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Spacer(
            flex: 4,
          ),
          Expanded(
            flex: 8,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${item.price}р",
                style: Theme.of(context)
                    .textTheme
                    .apply(bodyColor: Colors.white, displayColor: Colors.white)
                    .headline6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final Cart cart;

  const CartPage({Key key, @required this.cart}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CartPageState();
}

class TablePicker extends StatefulWidget {
  final Cart cart;

  const TablePicker({Key key, @required this.cart}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TablePickerState();
}

class _TablePickerState extends State<TablePicker> {
  int _currentValue = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(width: 2, color: Colors.white),
        borderRadius: BorderRadius.all(const Radius.circular(15)),
      ),
      child: Column(
        children: <Widget>[
          NumberPicker(
            value: _currentValue,
            minValue: 0,
            maxValue: 100,
            onChanged: (value) => setState(() {
              _currentValue = value;
              widget.cart.table = value;
            }),
            itemHeight: 30,
          ),
        ],
      ),
    );
  }
}

class _CartPageState extends State<CartPage> {
  Future<void> _showDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.only(top: 30, bottom: 30),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  image: AssetImage("assets/images/logo.png"),
                ),
                Center(
                  child: Text(
                    "Спасибо за заказ!",
                    style: Theme.of(context)
                        .textTheme
                        .apply(
                            bodyColor: Colors.white, displayColor: Colors.white)
                        .headline5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> uploadCart(Cart cart) async {
    String text = cart.toString();
    List<int> encoded = utf8.encode(text);
    Uint8List data = Uint8List.fromList(encoded);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/hello-world.text')
          .putData(data);
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back))
        ],
        leading: Container(
          child: Image(
            image: AssetImage("assets/images/logo.png"),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Заказ",
                style: Theme.of(context)
                    .textTheme
                    .apply(bodyColor: Colors.white, displayColor: Colors.white)
                    .headline4,
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: widget.cart.items.entries
                    .toList()
                    .map((e) => CartItemWidget(
                        item: e.key, count: e.value, cartPageState: this))
                    .toList(),
              ),
            ),
            if (widget.cart.table == null) TablePicker(cart: widget.cart),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${widget.cart.totalPrice}р",
                    style: Theme.of(context)
                        .textTheme
                        .apply(
                            bodyColor: Colors.white, displayColor: Colors.white)
                        .headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () async {
                        uploadCart(widget.cart);
                        widget.cart.clear();
                        await _showDialog();
                        Navigator.of(context).pop();
                      },
                      child: Text("Оформить заказ"),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void addItem(MenuItem item) {
    setState(() {
      widget.cart.addItem(item);
    });
  }

  void removeItem(MenuItem item) {
    setState(() {
      widget.cart.removeItem(item);
    });
  }
}

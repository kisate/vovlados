import 'common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:numberpicker/numberpicker.dart';

class Cart {
  final items = Map<MenuItem, int>();
  int totalPrice = 0;

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
    if (items.containsKey(item)) {
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
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Image(image: AssetImage(item.imageUrl)),
        ),
        Column(
          children: [
            Text(
              item.name,
              style: Theme.of(context)
                  .textTheme
                  .apply(bodyColor: Colors.white, displayColor: Colors.white)
                  .headline6,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: ElevatedButton(
                    onPressed: () {
                      cartPageState.addItem(item);
                    },
                    child: Text("+"),
                  ),
                ),
                Text(
                  "$count",
                  style: Theme.of(context)
                      .textTheme
                      .apply(
                          bodyColor: Colors.white, displayColor: Colors.white)
                      .headline6,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: ElevatedButton(
                      onPressed: () {
                        cartPageState.removeItem(item);
                      },
                      child: Text("-")),
                ),
              ],
            ),
          ],
        ),
        Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "${item.price}р",
            style: Theme.of(context)
                .textTheme
                .apply(bodyColor: Colors.white, displayColor: Colors.white)
                .headline6,
          ),
        ),
      ],
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
      ),
      child: Column(
        children: <Widget>[
          NumberPicker(
            value: _currentValue,
            minValue: 0,
            maxValue: 100,
            onChanged: (value) => setState(() => _currentValue = value),
          ),
          Text('Current value: $_currentValue'),
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
            padding: EdgeInsets.only(
              top: 30,
              bottom: 30
            ),
            decoration: BoxDecoration(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        leading: Image(
          image: AssetImage("assets/images/logo.png"),
          fit: BoxFit.fitHeight,
        ),
        actions: [
          Image(
            image: AssetImage("assets/images/logo.png"),
            fit: BoxFit.fitHeight,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Text(
              "Заказ",
              style: Theme.of(context)
                  .textTheme
                  .apply(bodyColor: Colors.white, displayColor: Colors.white)
                  .headline6,
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
            TablePicker(),
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
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ElevatedButton(
                    onPressed: () async {
                      widget.cart.clear();
                      await _showDialog();
                      Navigator.of(context).pop();
                    },
                    child: Text("Оформить заказ"),
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
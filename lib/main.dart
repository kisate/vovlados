import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'common.dart';
import 'cart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class MenuHeader extends StatelessWidget {
  final String title;

  const MenuHeader({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment(0.7, 0.5),
            end: Alignment(2, 0.5),
            colors: [
              Colors.black12,
              Colors.white54,
            ],
            tileMode: TileMode.mirror),
      ),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .apply(bodyColor: Colors.white, displayColor: Colors.white)
            .headline5,
      ),
    );
  }
}

class MenuSectionWidget extends StatelessWidget {
  final List<MenuItem> items;
  final _MyHomePageState homePage;

  const MenuSectionWidget(
      {Key key, @required this.items, @required this.homePage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: items
          .map((item) => GestureDetector(
                onTap: () {
                  homePage.addItem(item);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage(item.imageUrl),
                              fit: BoxFit.fitWidth,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                item.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .apply(
                                        bodyColor: Colors.white,
                                        displayColor: Colors.white)
                                    .headline6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "${item.price}руб",
                          style: Theme.of(context)
                              .textTheme
                              .apply(
                                  bodyColor: Colors.white,
                                  displayColor: Colors.white)
                              .headline6,
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class MenuTab extends StatefulWidget {
  final String name;

  const MenuTab({Key key, @required this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MenuTabState();
}

class MenuTabState extends State<MenuTab> {
  bool picked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Text(
        widget.name,
        style: Theme.of(context).textTheme.headline6,
      ),
      decoration: BoxDecoration(
        color: picked ? Colors.grey : Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(20)),
      ),
    );
  }

  void _toggle() {
    setState(() {
      picked = !picked;
    });
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Cart cart = Cart();
  final _menuScrollController = AutoScrollController(
    axis: Axis.vertical,
  );
  final _tabScrollController = AutoScrollController(
    axis: Axis.horizontal,
  );
  final List<MenuSection> menu = new List<MenuSection>.generate(
    7,
    (index) => MenuSection(
      "Section $index",
      new List<MenuItem>.generate(
        11,
        (index) => MenuItem("Item $index", 400, "assets/images/hach.png"),
      ),
    ),
  );

  void addItem(MenuItem item) {
    setState(() {
      cart.addItem(item);
    });
  }

  void removeItem(MenuItem item) {
    setState(() {
      cart.removeItem(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Colors.grey[900],
        leading: Image(
          image: AssetImage("assets/images/logo.png"),
          fit: BoxFit.fitHeight,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SingleChildScrollView(
                    controller: _tabScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        menu.length,
                        (index) => AutoScrollTag(
                          key: ValueKey(index),
                          controller: _tabScrollController,
                          index: index,
                          child: GestureDetector(
                            onTap: () {
                              _menuScrollController.scrollToIndex(2 * index,
                                  preferPosition: AutoScrollPosition.begin);
                            },
                            child: MenuTab(name: menu[index].name),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _menuScrollController,
                      itemCount: menu.length * 2,
                      itemBuilder: (BuildContext context, int index) {
                        return AutoScrollTag(
                          key: ValueKey(index),
                          controller: _menuScrollController,
                          index: index,
                          child: index % 2 == 0
                              ? VisibilityDetector(
                                  key: Key(index.toString()),
                                  onVisibilityChanged: (VisibilityInfo info) {
                                    if (info.visibleFraction == 1)
                                      _tabScrollController.scrollToIndex(
                                          index ~/ 2,
                                          preferPosition:
                                              AutoScrollPosition.begin);
                                  },
                                  child:
                                      MenuHeader(title: menu[index ~/ 2].name),
                                )
                              : MenuSectionWidget(
                                  items: menu[index ~/ 2].items,
                                  homePage: this,
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: cart.totalPrice > 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CartPage(cart: this.cart)),
                      );
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Оформить заказ",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "${cart.totalPrice}р",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius:
                            BorderRadius.all(const Radius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

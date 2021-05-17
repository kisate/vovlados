class MenuItem {
  final String name;
  final int price;
  final String imageUrl;

  MenuItem(this.name, this.price, this.imageUrl);

  MenuItem.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        imageUrl = json["imageUrl"],
        price = json["price"];
}

class MenuSection {
  final String name;
  final List<MenuItem> items;

  MenuSection(this.name, this.items);

  MenuSection.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        items = List<MenuItem>.from((json["items"] as List).map((item) => MenuItem.fromJson(item)));
}
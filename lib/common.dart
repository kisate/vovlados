class MenuItem {
  final String name;
  final int price;
  final String imageUrl;

  MenuItem(this.name, this.price, this.imageUrl);
}

class MenuSection {
  final String name;
  final List<MenuItem> items;

  MenuSection(this.name, this.items);
}
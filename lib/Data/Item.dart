
class Item {
  final String name;
  bool selected;

  Item({required this.name, this.selected = false});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      selected: false,
    );
  }
}
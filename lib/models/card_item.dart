class CardItem {
  final String id;
  final String name;
  final String icon;
  final double price;
  final String type; // 'fakka' or 'mared'
  final String? badge;

  CardItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.price,
    required this.type,
    this.badge,
  });

  factory CardItem.fromJson(Map<String, dynamic> json) {
    return CardItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '💳',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      type: json['type']?.toString() ?? 'fakka',
      badge: json['badge']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'price': price,
        'type': type,
        'badge': badge,
      };
}

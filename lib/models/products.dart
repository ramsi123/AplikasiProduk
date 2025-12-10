class Products {
  final int id;
  final String title;
  final double price;
  final String category;
  final String image;

  Products({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.image,
  });

  factory Products.fromMap(Map<String, dynamic> map) {
    return Products(
      id: map['id'] as int,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      category: map['category'] as String,
      image: map['image'] as String,
    );
  }
}

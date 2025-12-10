class ProductDetail {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  ProductDetail({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory ProductDetail.fromMap(Map<String, dynamic> map) {
    return ProductDetail(
      id: map['id'] as int,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      category: map['category'] as String,
      image: map['image'] as String,
    );
  }
}

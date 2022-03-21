class Product {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorites = true;

  Product(
      {required this.id,
      required this.description,
      required this.imageUrl,
       required this.price,
      required this.title,
      });
}

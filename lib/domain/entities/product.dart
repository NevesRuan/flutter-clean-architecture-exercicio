class Product {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final String description;
  final String category;
  final double rating;
  final int stock;
  bool favorite;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.description,
    required this.category,
    required this.rating,
    required this.stock,
    this.favorite = false,
  });
}

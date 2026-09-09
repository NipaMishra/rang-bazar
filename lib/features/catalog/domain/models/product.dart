class Rating {
  const Rating({required this.rate, required this.count});

  final double rate;
  final int count;

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num?)?.toDouble() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  factory Product.fromJson(Map<String, dynamic> json) {
    final Object? ratingRaw = json['rating'];
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: ratingRaw is Map<String, dynamic>
          ? Rating.fromJson(ratingRaw)
          : const Rating(rate: 0, count: 0),
    );
  }
}

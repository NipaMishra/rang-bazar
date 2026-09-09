class Category {
  const Category({required this.slug});

  final String slug;

  factory Category.fromApi(String slug) => Category(slug: slug.trim());
}

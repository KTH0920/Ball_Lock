class Category {
  final String id;
  final String name;
  final List<String> subCategories;

  Category({
    required this.id,
    required this.name,
    this.subCategories = const [],
  });
}

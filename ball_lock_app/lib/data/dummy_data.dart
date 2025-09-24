import '../models/stadium.dart';
import '../models/category.dart';

final List<Stadium> dummyStadiums = [
  Stadium(
    id: "s1",
    name: "S1",
    categories: [
      Category(id: "c1", name: "Food", subCategories: ["Pizza", "Burger", "Sandwich"]),
      Category(id: "c2", name: "Drinks", subCategories: ["Coke", "Beer"]),
    ],
  ),
  Stadium(
    id: "s2",
    name: "S2",
    categories: [
      Category(id: "c1", name: "Snacks", subCategories: ["Popcorn", "Chips"]),
      Category(id: "c2", name: "Desserts", subCategories: ["Ice Cream", "Cake"]),
    ],
  ),
  // 나머지 8개도 여기에 추가하면 됨
];

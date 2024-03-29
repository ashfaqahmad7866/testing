import 'package:testing/models/category.dart';
import 'package:testing/models/grocery_item.dart';
import 'package:testing/data/categories.dart';
final groceryItems = [
  GroceryItem(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      categories: categories[Categories.dairy]!),
  GroceryItem(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      categories: categories[Categories.fruit]!),
  GroceryItem(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      categories: categories[Categories.meat]!),
];
import 'package:testing/models/category.dart';

class GroceryItem{
 const GroceryItem({required this.id,required this.name, required this.quantity,required this.categories});
 final String id;
  final String name;
  final int quantity;
  final Category categories;

}
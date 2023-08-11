 import 'package:flutter/material.dart';

enum Categories {
    vegetables,
    fruit, 
    meat,
    dairy,
    carbs,
    spices,
    sweets,
    convenience,
    hygiene,
    other
  }
class Category{
 const Category({required this.categories, required this.color});
 final String categories;
 final Color color;
}
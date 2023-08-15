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
 const Category({required this.title, required this.color});
 final String title;
 final Color color;
}
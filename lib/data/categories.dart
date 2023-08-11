import 'package:flutter/material.dart';

import 'package:testing/models/category.dart';
const categories = {
  Categories.vegetables: Category(categories: 
    'Vegetables',color: 
    Color.fromARGB(255, 0, 255, 128),
  ),
  Categories.fruit: Category(categories: 
    'Fruit',color: 
    Color.fromARGB(255, 145, 255, 0),
  ),
  Categories.meat: Category(categories: 
    'Meat',color: 
    Color.fromARGB(255, 255, 102, 0),
  ),
  Categories.dairy: Category(categories: 
    'Dairy',color: 
    Color.fromARGB(255, 0, 208, 255),
  ),
  Categories.carbs: Category(categories: 
    'Carbs',color: 
    Color.fromARGB(255, 0, 60, 255),
  ),
  Categories.sweets: Category(categories: 
    'Sweets',color: 
    Color.fromARGB(255, 255, 149, 0),
  ),
  Categories.spices: Category(categories: 
    'Spices',color: 
    Color.fromARGB(255, 255, 187, 0),
  ),
  Categories.convenience: Category(categories: 
    'Convenience',color: 
    Color.fromARGB(255, 191, 0, 255),
  ),
  Categories.hygiene: Category(categories: 
    'Hygiene',color: 
    Color.fromARGB(255, 149, 0, 255),
  ),
  Categories.other: Category(categories: 
    'Other',color: 
    Color.fromARGB(255, 0, 225, 255),
  ),
};
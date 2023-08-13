// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:testing/data/categories.dart';
import 'package:testing/models/category.dart';
import 'package:testing/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return NewItemState();
  }
}

class NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var name;
  var quantity=1;
  var category=categories[Categories.dairy]!;
  void _saveITems() {
   if( _formKey.currentState!.validate()){
    _formKey.currentState!.save();
    Navigator.of(context).pop(
      GroceryItem(id: DateTime.now().toString(), name: name, quantity: quantity, category: category)
    );
    print(name);
    print(quantity);
    print(category);
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        value == null ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Values must be between 1 and 50 characters';
                    }
                    return null;
                  },
                  onSaved: (newValue) => name = newValue!),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: quantity.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      validator: (value) {
                        if (value!.isEmpty ||
                            value == null ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 1) {
                          return 'Must be a valid positive number';
                        }
                        return null;
                      },
                      onSaved: (value) => quantity=int.parse(value!),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: category,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(category.value.categories),
                              ],
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          category=value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveITems,
                    child: const Text('Add new'),
                  ),
                  //OR
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Validate returns true if the form is valid, or false otherwise.
                  //     if (_formKey.currentState!.validate()) {
                  //       // If the form is valid, display a snackbar. In the real world,
                  //       // you'd often call a server or save the information in a database.
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(content: Text('Processing Data')),
                  //       );
                  //     }
                  //   },
                  //   child: const Text('Submit'),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

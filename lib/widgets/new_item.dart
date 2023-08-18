// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:testing/data/categories.dart';
import 'package:testing/models/category.dart';
import 'package:testing/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return NewItemState();
  }
}

class NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _isSending = false;
  String? response;
  // ignore: prefer_typing_uninitialized_variables
  var name;
  var quantity = 1;
  var category = categories[Categories.dairy]!;
  void _saveITems() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      _formKey.currentState!.save();
      final url = Uri.https(
          'flutter-preparation-98c2f-default-rtdb.firebaseio.com',
          'shopping-list.json');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
            {
              'name': name,
              'quantity': quantity,
              'category': category.title,
            },
          ),
        );
        final Map<String, dynamic> getId = json.decode(response.body);
        if (!context.mounted) {
          return;
        } else
        //  {
        //   Navigator.of(context).pop();
        // }
        {
          //OR
//.then((response) {
// response.body;//it's the response from firease with the data
// response.statusCode;//it's used to check whether data is successfully submitted or not: 200 for success: 400/500, for error
//       });
          Navigator.of(context).pop(
            GroceryItem(
              id: getId['name'],
              name: name,
              quantity: quantity,
              categories: category,
            ),
          );
        }
      } catch (error) {
        return;
      }
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
                      onSaved: (value) => quantity = int.parse(value!),
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
                                Text(category.value.title),
                              ],
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          category = value!;
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
                    onPressed: _isSending
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveITems,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Add new'),
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

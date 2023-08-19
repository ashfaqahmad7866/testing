// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:testing/data/categories.dart';
// import 'package:testing/models/category.dart';
import 'package:testing/models/grocery_item.dart';
import 'package:testing/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroceryList extends StatefulWidget {
  const GroceryList({Key? key}) : super(key: key);
  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  late Future<List<GroceryItem>> _loadedItems;
  Future<List<GroceryItem>> _loadItems() async {
    final url = Uri.https(
        'flutter-preparation-98c2f-default-rtdb.firebaseio.com',
        'shopping-list.json');
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      throw Exception(
          'Failed to fetch items, try again later!'); //Future method will be rejected and snapshot.haserror method will work now
    }
    if (response.body ==
        'null') //if there is no data in db, we will see progress bar only, that's way we have added this check, firebase returns null as a string
    {
      return [];
    }
    final Map<String, dynamic> listData = json.decode(response.body);
     List<GroceryItem> tempList = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (catItems) => catItems.value.title == item.value['category'])
          .value;
      tempList.add(
        GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            categories: category),
      );
    }
    return tempList;
  }  

  @override
  void initState() {
    super.initState();
 _loadedItems= _loadItems(); //we assign response value to a new list bcz we want to execute the respone for only one time when screen loads, otherwise we had to pass reponse method as a calling getResponse() in futureBuilder method which would build every time when the ui uppdate
  }

  List<GroceryItem> groceryItems = [];
  void _addItem() async {
    // final newItem = await
    final newItem = await Navigator.of(context)
        .push<GroceryItem>(MaterialPageRoute(builder: (ctx) {
      return const NewItem();
    }));

    if (newItem == null) {
      return; // we put this condition bcz new item page could be null if users switch back to this page without entering any data
    }
    setState(() {
      groceryItems.add(newItem);
    });
    // _loadedItems();
  }

  @override
  Widget build(BuildContext context) {
    void removeItem(GroceryItem g) async {
      final url = Uri.https(
          'flutter-preparation-98c2f-default-rtdb.firebaseio.com',
          'shopping-list/${g.id}.json');
      var response = await http.delete(url);
      final groceryIndex = groceryItems.indexOf(g);
      if (response.statusCode >= 400) {
        //managing
        setState(() {
          groceryItems.insert(groceryIndex, g);
        });
      }
      setState(() {
        groceryItems.remove(g);
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Item deleted!'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              groceryItems.insert(groceryIndex, g);
            });
          },
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: FutureBuilder(
        future: _loadedItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return  const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.data!.isEmpty) {
           return const Center(
              child: Text(
                'No item found. try to add some!',
                style: TextStyle(
                    fontFamily: AutofillHints.creditCardExpirationDay,
                    fontWeight: FontWeight.bold),
              ),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            Theme.of(context).canvasColor.red.toDouble()),
                  ),
                  key:
                      UniqueKey(), //key Should be different for every list item i.e. id
                  child: ListTile(
                      leading: Container(
                        width: 24,
                        height: 24,
                        color: snapshot.data![index].categories.color,
                      ),
                      trailing: Text(snapshot.data![index].quantity.toString()),
                      title: Text(snapshot.data![index].name)),
                  onDismissed: (direction) => removeItem(snapshot.data![index]),
                );
              });
        },
      ),
    );
  }
}

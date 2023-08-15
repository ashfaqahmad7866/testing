import 'package:flutter/material.dart';
import 'package:testing/data/categories.dart';
// import 'package:testing/models/category.dart';
import 'package:testing/models/grocery_item.dart';
import 'package:testing/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroceryList extends StatefulWidget {
  const GroceryList({Key? key, required this.groceryItem}) : super(key: key);
  final List<GroceryItem> groceryItem;
  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  void _getResponse() async {
    final url = Uri.https(            
        'flutter-preparation-98c2f-default-rtdb.firebaseio.com',
        'shopping-list.json');
    final response = await http.get(url);
    print(response.body);
    final Map<String,dynamic> listData =
        json.decode(response.body);
    final List<GroceryItem> tempList = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere((catItems) =>
              catItems.value.title == item.value['category'])
          .value;
      tempList.add(
        GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            categories: category),
      );
    }
    setState(() {
     groceryItems =tempList;
    });
  }

  @override
  void initState() {
    super.initState();
    _getResponse();
  }

   List<GroceryItem> groceryItems = [];
  void _addItem() async {
    // final newItem = await
    Navigator.of(context).push<GroceryItem>(MaterialPageRoute(builder: (ctx) {
      return const NewItem();
    }));
    // if (newItem == null) {
    //   return; // we put this condition bcz new item page could be null if users switch back to this page without entering any data
    // }
    // setState(() {
    //   groceryItems.add(newItem);
    // });
    _getResponse();
  }

  @override
  Widget build(BuildContext context) {
    void removeItem(GroceryItem g) {
      final groceryIndex = groceryItems.indexOf(g);
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

    Widget currentScreen;
    if (groceryItems.isEmpty) {
      currentScreen = const Center(
        child: Text(
          'No item found. try to add some!',
          style: TextStyle(
              fontFamily: AutofillHints.creditCardExpirationDay,
              fontWeight: FontWeight.bold),
        ),
      );
    } else {
      currentScreen = ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (context, index) {
            return Dismissible(
              background: Container(
                color: Colors.red,
                margin: EdgeInsets.symmetric(
                    horizontal: Theme.of(context).canvasColor.red.toDouble()),
              ),
              key: ValueKey(groceryItems[index]
                  .id), //key Should be different for every list item i.e. id
              child: ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: groceryItems[index].categories.color,
                  ),
                  trailing: Text(groceryItems[index].quantity.toString()),
                  title: Text(groceryItems[index].name)),
              onDismissed: (direction) => removeItem(groceryItems[index]),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: currentScreen,
    );
  }
}

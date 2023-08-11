import 'package:flutter/material.dart';
import 'package:testing/models/grocery_item.dart';
import 'package:testing/widgets/new_item.dart';

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({Key? key, required this.groceryItem})
      : super(key: key);
  final List<GroceryItem> groceryItem;
  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  void _addItem() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const NewItem()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: ListView.builder(
          itemCount: widget.groceryItem.length,
          itemBuilder: (context, index) {
            return ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  color: widget.groceryItem[index].category.color,
                ),
                trailing: Text(widget.groceryItem[index].quantity.toString()),
                title: Text(widget.groceryItem[index].name));
          }),
    );
  }
}

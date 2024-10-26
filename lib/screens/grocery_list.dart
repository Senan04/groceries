import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:groceries/models/grocery_item.dart';
import 'package:groceries/screens/add_item.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final List<GroceryItem> groceries = [];

  void _addItem() async {
    final addedItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const AddItemScreen()));

    if (addedItem != null) {
      setState(() {
        groceries.add(addedItem);
      });
    }
  }

  void _deleteItem(int index) {
    setState(() {
      groceries.removeAt(index);
    });
  }

  Widget get _content {
    if (groceries.isEmpty) {
      return Center(
        child: Text(
          'There are no items in your Shopping List!',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.amber.shade50),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: groceries.length,
        itemBuilder: (ctx, index) => Slidable(
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                onPressed: (ctx) => _deleteItem(index),
                icon: Icons.delete,
                label: 'Delete',
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
            ],
          ),
          child: ListTile(
            leading: ColoredBox(
              color: groceries[index].category.categoryColor,
              child: const SizedBox.square(
                dimension: 20,
              ),
            ),
            title: Text(groceries[index].name),
            trailing: Text(
              groceries[index].quantity.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: _content,
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}

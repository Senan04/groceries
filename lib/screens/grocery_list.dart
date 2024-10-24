import 'package:flutter/material.dart';
import 'package:groceries/data/dummy_items.dart';
import 'package:groceries/screens/add_Item.dart';

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});

  Widget _content(BuildContext context) {
    if (groceryItems.isEmpty) {
      return Center(
        child: Text(
          'There are no Items in your Shopping List!',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => ListTile(
          leading: ColoredBox(
            color: groceryItems[index].category.categoryColor,
            child: const SizedBox.square(
              dimension: 20,
            ),
          ),
          title: Text(groceryItems[index].name),
          trailing: Text(
            groceryItems[index].quantity.toString(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white),
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
      body: _content(context),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const AddItemScreen()))),
    );
  }
}

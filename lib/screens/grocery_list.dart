import 'package:flutter/material.dart';
import 'package:groceries/data/categories.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:groceries/models/grocery_item.dart';
import 'package:groceries/screens/add_item.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<GroceryItem> _groceries = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      'flutter-prep-87326-default-rtdb.europe-west1.firebasedatabase.app',
      'shopping-list.json',
    );
    final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to load. Please try again later !';
        _isLoading = false;
      });
      return;
    }

    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> groceriesFromJSON = json.decode(response.body);
    final List<GroceryItem> loadedGroceries = groceriesFromJSON.entries
        .map((entry) => GroceryItem(
            id: entry.key,
            category: categories.entries
                .firstWhere((catItem) =>
                    catItem.value.category == entry.value['category'])
                .value,
            name: entry.value['name'],
            quantity: entry.value['quantity']))
        .toList();
    setState(() {
      _groceries = loadedGroceries;
      _isLoading = false;
    });
  }

  void _addItem() async {
    final addedItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const AddItemScreen()));
    if (addedItem != null) {
      setState(() {
        _groceries.add(addedItem);
      });
    }
  }

  void _deleteItem(int index) async {
    final groceryItem = _groceries[index];

    setState(() {
      _groceries.remove(groceryItem);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBarController = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted ${groceryItem.name}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() {
            _groceries.insert(index, groceryItem);
          }),
        ),
      ),
    );
    final reason = await snackBarController.closed;
    if (reason == SnackBarClosedReason.action) return;

    final url = Uri.https(
      'flutter-prep-87326-default-rtdb.europe-west1.firebasedatabase.app',
      'shopping-list/${groceryItem.id}.json',
    );
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to delete the item. Please try again!')));
      }
      setState(() {
        _groceries.insert(index, groceryItem);
      });
    }
  }

  Widget get _content {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_error != null) {
      return Center(child: Text(_error!));
    } else if (_groceries.isEmpty) {
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
        itemCount: _groceries.length,
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
              color: _groceries[index].category.categoryColor,
              child: const SizedBox.square(
                dimension: 20,
              ),
            ),
            title: Text(_groceries[index].name),
            trailing: Text(
              _groceries[index].quantity.toString(),
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

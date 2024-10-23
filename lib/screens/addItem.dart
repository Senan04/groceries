import 'package:flutter/material.dart';
import 'package:groceries/data/categories.dart';
import 'package:groceries/data/dummy_items.dart';
import 'package:groceries/models/category.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new item"),
      ),
      body: Form(
        child: Column(
          children: [
            TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
              validator: (value) => 'Demo...',
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Quantity'),
                    ),
                    initialValue: '1',
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField(
                      items: [DropdownMenuItem(child: Placeholder())],
                      onChanged: (x) {}),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

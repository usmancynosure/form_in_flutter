import 'package:flutter/material.dart';
import 'package:grocessory_app/model/grocessory_item.dart';
import 'package:grocessory_app/widgets/Add_item.dart';

class addedItems extends StatefulWidget {
  const addedItems({Key? key}) : super(key: key);

  @override
  State<addedItems> createState() => _addedItemsState();
}

class _addedItemsState extends State<addedItems> {
  final grocessoryitem = [];

  // Method to remove a grocery item
  void onRemoveGrocery(GroceryItem item) {
    //removed item index
    final index = grocessoryitem.indexOf(item);
    setState(() {
      grocessoryitem.remove(item);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("item removed"),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: "undo",
          onPressed: () {
            setState(() {
              grocessoryitem.insert(index, item);
            });
          },
        ),
      ),
    );
  }

  void _navigateToAddItem() async {
    final items = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const newItem(),
      ),
    );

    if (items == null) {
      return;
    }

    setState(() {
      grocessoryitem.add(items);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show text if no item is available
    Widget result = grocessoryitem.isEmpty
        ? const Center(
            child: Text(
              "No items - Click the icon to Add",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        : ListView.builder(
            itemCount: grocessoryitem.length,
            itemBuilder: (context, index) {
              final item = grocessoryitem[index];
              return Dismissible(
                background: Container(
                  color: Theme.of(context)
                      .colorScheme
                      .error
                      .withOpacity(0.5), // Slightly transparent
                ),
                onDismissed: (direction) {
                  onRemoveGrocery(grocessoryitem[index]);
                },
                key: Key(item.name), // Unique key for the dismissed item
                child: ListTile(
                  leading: Container(
                    width: 35,
                    height: 35,
                    color: item.category.color,
                  ),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  trailing: Text(
                    item.quantity.toString(),
                    style:
                        Theme.of(context).primaryTextTheme.bodyText2!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                  ),
                ),
              );
            },
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Groceries"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddItem(),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(child: result),
        ],
      ),
    );
  }
}

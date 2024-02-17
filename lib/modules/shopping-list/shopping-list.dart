import 'package:flutter/material.dart';

class ShoppingListItem {
  ShoppingListItem({required this.title, required this.checked});
  String title;
  bool checked;
}

class ShoppingListPage extends StatefulWidget {
  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final List<ShoppingListItem> _shoppingList = <ShoppingListItem>[];
  final TextEditingController _shoppingListItemAddController =
      TextEditingController();

  void _addShoppingListItem(String name) {
    setState(() {
      _shoppingList.add(ShoppingListItem(title: name, checked: false));
    });
    _shoppingListItemAddController.clear();
  }

  void _handleShoppingItemChange(ShoppingListItem shoppingListItem) {
    setState(() {
      shoppingListItem.checked = !shoppingListItem.checked;
    });
  }

  void _deleteShoppingItem(ShoppingListItem shoppingListItem) {
    setState(() {
      _shoppingList
          .removeWhere((element) => element.title == shoppingListItem.title);
    });
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Shopping List Item'),
            content: TextField(
              controller: _shoppingListItemAddController,
              decoration: const InputDecoration(hintText: 'Type your item'),
              autofocus: true,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addShoppingListItem(_shoppingListItemAddController.text);
                  },
                  child: const Text('Add'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Shopping List'),
      ),
      body: ListView(
        children: _shoppingList.map((ShoppingListItem shoppingListItem) {
          return ShoppingItem(
              shoppingListItem: shoppingListItem,
              onShoppingListItemChanged: _handleShoppingItemChange,
              deleteShoppingListItem: _deleteShoppingItem);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(),
        tooltip: 'Add Shopping List Item',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ShoppingItem extends StatelessWidget {
  ShoppingItem(
      {required this.shoppingListItem,
      required this.onShoppingListItemChanged,
      required this.deleteShoppingListItem})
      : super(key: ObjectKey(shoppingListItem));

  final ShoppingListItem shoppingListItem;
  final void Function(ShoppingListItem shoppingListItem)
      onShoppingListItemChanged;

  final void Function(ShoppingListItem shoppingListItem) deleteShoppingListItem;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(decoration: TextDecoration.lineThrough);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        onTap: () {
          onShoppingListItemChanged(shoppingListItem);
        },
        leading: Checkbox(
          checkColor: Colors.white,
          activeColor: Theme.of(context).colorScheme.primary,
          value: shoppingListItem.checked,
          onChanged: (value) {
            onShoppingListItemChanged(shoppingListItem);
          },
        ),
        title: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              shoppingListItem.title,
              style: _getTextStyle(shoppingListItem.checked),
            )),
            IconButton(
              onPressed: () {
                deleteShoppingListItem(shoppingListItem);
              },
              icon: const Icon(
                Icons.delete,
              ),
              alignment: Alignment.centerRight,
            )
          ],
        ),
      ),
    );
  }
}

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
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onShoppingListItemChanged(shoppingListItem);
      },
      leading: Checkbox(
        checkColor: Colors.greenAccent,
        activeColor: Colors.red,
        value: shoppingListItem.checked,
        onChanged: (value) {
          onShoppingListItemChanged(shoppingListItem);
        },
      ),
      title: Row(
        children: <Widget>[
          Expanded(child: Text(shoppingListItem.title)),
          IconButton(
            onPressed: () {
              deleteShoppingListItem(shoppingListItem);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            alignment: Alignment.centerRight,
          )
        ],
      ),
    );
  }
}

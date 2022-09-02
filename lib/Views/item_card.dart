import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:old_ephraim_app/Models/itemModel.dart';
import 'package:provider/provider.dart';

import '../Providers/UserViewModel.dart';

class ItemCard extends StatefulWidget {
  const ItemCard(
      {Key? key,
      required this.itemModel,
      required this.counter,
      required this.index})
      : super(key: key);

  final ItemModel itemModel;
  final int counter;
  final int index;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final DateFormat intoDbFormatter = DateFormat('yyyy-MM-dd H:m:s');
  void updateCounter() {
    var userVM = Provider.of<UserViewModel>(context, listen: false);
    final newCount = widget.counter + widget.itemModel.changeAmount;
    var db = FirebaseDatabase.instance;

    db
        .ref("/users/${userVM.currentUser?.uid}/counts/breakfast")
        .update({widget.itemModel.databaseName: newCount});

    db
        .ref("/users/${userVM.currentUser?.uid}/lastUpdate")
        .set(intoDbFormatter.format(DateTime.now()));
  }

  Future<void> _showUndoDialog() async {
    return showDialog<void>(
      context: context, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Undo Count'),
          content: const Text('This will remove a count from this item.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                undoCounter();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void undoCounter() {
    var userVM = Provider.of<UserViewModel>(context, listen: false);

    if (widget.counter != 0) {
      final newCount = widget.counter - widget.itemModel.changeAmount;
      var db = FirebaseDatabase.instance;

      db
          .ref("/users/${userVM.currentUser?.uid}/counts/breakfast")
          .update({widget.itemModel.databaseName: newCount});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: updateCounter,
      onLongPress: _showUndoDialog,
      child: Card(
        child: ListTile(
          leading: Icon(widget.itemModel.iconToDisplay),
          title: Text(widget.itemModel.title),
          trailing: Text(widget.counter.toString()),
        ),
      ),
    );
  }
}

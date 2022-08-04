import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:old_ephraim_app/Models/itemModel.dart';

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
  void updateCounter() {
    final newCount = widget.counter + widget.itemModel.changeAmount;
    FirebaseDatabase.instance
        .ref("/users/Alaina/counts/breakfast")
        .set({widget.itemModel.databaseName: newCount});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: updateCounter,
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

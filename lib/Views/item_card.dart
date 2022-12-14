import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  void updateCounter() {
    var userVM = Provider.of<UserViewModel>(context, listen: false);
    final newCount = widget.counter + widget.itemModel.changeAmount;
    FirebaseDatabase.instance
        .ref("/users/${userVM.currentUser?.uid}/counts/breakfast")
        .update({widget.itemModel.databaseName: newCount});
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

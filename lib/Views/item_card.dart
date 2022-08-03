import 'package:flutter/material.dart';
import 'package:old_ephraim_app/Models/itemModel.dart';

class ItemCard extends StatefulWidget {
  const ItemCard(
      {Key? key,
      required this.itemModel,
      required this.counter,
      required this.changeCallBack,
      required this.index})
      : super(key: key);

  final ItemModel itemModel;
  final int counter;
  final Function(int, int) changeCallBack;
  final int index;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  void updateCounter() {
    widget.changeCallBack(widget.itemModel.changeAmount, widget.index);
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

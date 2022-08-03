// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../Models/itemModel.dart';
import 'package:old_ephraim_app/Views/item_card.dart';

class DailyCounts extends StatefulWidget {
  const DailyCounts({Key? key}) : super(key: key);

  @override
  State<DailyCounts> createState() => _DailyCountsState();
}

class _DailyCountsState extends State<DailyCounts> {
  List<int> itemCounts = [0, 0, 0, 0, 0, 0];
  List<ItemModel> itemModels = [
    ItemModel(
        title: "Intense Exercise",
        changeAmount: 5,
        iconToDisplay: Icons.directions_run),
    ItemModel(
        title: "Moderate Exercise",
        changeAmount: 3,
        iconToDisplay: Icons.accessibility),
    ItemModel(
        title: "Fruits/Veggies",
        changeAmount: 5,
        iconToDisplay: Icons.done_all),
    ItemModel(title: "Whole Foods", changeAmount: 2, iconToDisplay: Icons.done),
    ItemModel(
        title: "Processed Foods",
        changeAmount: -3,
        iconToDisplay: Icons.mood_bad),
    ItemModel(
        title: "Ultra-Processed Crap",
        changeAmount: -10,
        iconToDisplay: Icons.delete)
  ];

  void updateCounter(int amountToUpdateBy, int index) {
    setState(() {
      itemCounts[index] += amountToUpdateBy;
    });
  }

  String getTotal() {
    var total = itemCounts.reduce((value, element) => value + element);
    return total.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: itemModels.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemCard(
                    itemModel: itemModels[index],
                    counter: itemCounts[index],
                    changeCallBack: updateCounter,
                    index: index,
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  height: 5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(
                getTotal(),
                style: const TextStyle(fontSize: 40),
              ),
            )
          ]),
    );
  }
}

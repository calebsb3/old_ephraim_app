// ignore_for_file: file_names

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/itemModel.dart';
import 'package:old_ephraim_app/Views/item_card.dart';

import '../Providers/UserViewModel.dart';

class DailyCounts extends StatefulWidget {
  const DailyCounts({Key? key}) : super(key: key);

  @override
  State<DailyCounts> createState() => _DailyCountsState();
}

class _DailyCountsState extends State<DailyCounts> {
  Map<String, int> itemCounts = {
    'intense_exercise': 0,
    'moderate_exercise': 0,
    'fruits_veggies': 0,
    'whole': 0,
    'processed': 0,
    'ultra_processed': 0
  };
  List<ItemModel> itemModels = [
    ItemModel(
        title: "Intense Exercise",
        databaseName: "intense_exercise",
        changeAmount: 5,
        iconToDisplay: Icons.directions_run),
    ItemModel(
        title: "Moderate Exercise",
        databaseName: "moderate_exercise",
        changeAmount: 3,
        iconToDisplay: Icons.accessibility),
    ItemModel(
        title: "Fruits/Veggies",
        databaseName: "fruits_veggies",
        changeAmount: 5,
        iconToDisplay: Icons.done_all),
    ItemModel(
        title: "Whole Foods",
        databaseName: "whole",
        changeAmount: 2,
        iconToDisplay: Icons.done),
    ItemModel(
        title: "Processed Foods",
        databaseName: "processed",
        changeAmount: -3,
        iconToDisplay: Icons.mood_bad),
    ItemModel(
        title: "Ultra-Processed Crap",
        databaseName: "ultra_processed",
        changeAmount: -10,
        iconToDisplay: Icons.delete)
  ];

  String getTotal() {
    var total = itemCounts.values.reduce((value, element) => value + element);
    return total.toString();
  }

  void updateCounts(Map<dynamic, dynamic> mappedCounts) {
    for (var nameAndCount in mappedCounts.entries) {
      if (itemCounts.containsKey(nameAndCount.key)) {
        setState(() {
          itemCounts[nameAndCount.key] = nameAndCount.value;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    var userVM = Provider.of<UserViewModel>(context, listen: false);

    FirebaseDatabase.instance
        .ref('/users/${userVM.currentUser?.uid}/counts/breakfast')
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      try {
        var dataMapped = data as Map;
        updateCounts(dataMapped);
      } catch (error) {
        print(error.toString());
      }
    });
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
                    counter: itemCounts[itemModels[index].databaseName] ?? 0,
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

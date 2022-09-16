// ignore_for_file: file_names

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/itemModel.dart';
import 'package:old_ephraim_app/Views/item_card.dart';

import '../Providers/UserViewModel.dart';
import '../Providers/counts_view_model.dart';

class DailyCounts extends StatefulWidget {
  const DailyCounts({Key? key}) : super(key: key);

  @override
  State<DailyCounts> createState() => _DailyCountsState();
}

class _DailyCountsState extends State<DailyCounts> {
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
  final _formKey = GlobalKey<FormState>();

  final newGoalController = TextEditingController();

  Future<void> _newWeekModal(BuildContext context) {
    var countsVM = Provider.of<CountsViewModel>(context, listen: false);
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            child: Form(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text("New Goal:")),
                        SizedBox(
                          width: 70,
                          child: TextFormField(
                            controller: newGoalController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              } else if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          countsVM
                              .startNewWeek(int.parse(newGoalController.text));
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Start New Week"),
                    )
                  ]),
              key: _formKey,
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    var userVM = Provider.of<UserViewModel>(context, listen: false);
    var countsVM = Provider.of<CountsViewModel>(context, listen: false);
    var db = FirebaseDatabase.instance;

    db
        .ref('/users/${userVM.currentUser?.uid}/counts/breakfast')
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      try {
        var dataMapped = data as Map;
        countsVM.updateCounts(dataMapped);
      } catch (error) {
        print(error.toString());
      }
    });

    db
        .ref('/users/${userVM.currentUser?.uid}/goal')
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      try {
        countsVM.updateGoal(data as int);
      } catch (error) {
        print(error.toString());
      }
    });

    db
        .ref('/users/${userVM.currentUser?.uid}/lastUpdate')
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      try {
        countsVM.updateLastUpdate(data as String);
      } catch (error) {
        print(error.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CountsViewModel>(
      builder: (context, countVM, child) {
        if (countVM.itemCountsLoaded) {
          return Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: ListView.separated(
                  itemCount: itemModels.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ItemCard(
                      itemModel: itemModels[index],
                      counter:
                          countVM.itemCounts[itemModels[index].databaseName] ??
                              0,
                      index: index,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 5,
                  ),
                ),
              ),
              Text("Last Time Updated: ${countVM.getLastUpdate()}"),
              Text(
                countVM.getTotalAndGoal(),
                style: const TextStyle(fontSize: 40),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: () {
                    _newWeekModal(context);
                  },
                  child: const Text("Start New Week"),
                ),
              )
            ]),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              value: null,
              color: Colors.blueGrey,
            ),
          );
        }
      },
    );
  }
}

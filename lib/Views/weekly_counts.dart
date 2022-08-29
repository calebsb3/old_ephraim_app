import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/UserViewModel.dart';
import '../Providers/counts_view_model.dart';

class WeeklyCounts extends StatefulWidget {
  const WeeklyCounts({Key? key}) : super(key: key);

  @override
  State<WeeklyCounts> createState() => _WeeklyCountsState();
}

class _WeeklyCountsState extends State<WeeklyCounts> {
  @override
  void initState() {
    super.initState();
    var userVM = Provider.of<UserViewModel>(context, listen: false);
    var countsVM = Provider.of<CountsViewModel>(context, listen: false);

    FirebaseDatabase.instance
        .ref('/users/${userVM.currentUser?.uid}/weeks_counts')
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      try {
        var dataMapped = data as Map;
        countsVM.updateWeeklyCounts(dataMapped);
      } catch (error) {
        print(error.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CountsViewModel>(builder: (context, countsVM, child) {
      return Center(
        child: Column(children: [
          const Padding(
              padding: EdgeInsets.only(top: 10, right: 150),
              child: Text("Week starting with:")),
          Expanded(
            child: ListView.separated(
              itemCount: countsVM.weeksCounts.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Card(
                    child: countsVM.returnDateFormatted(index),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 5,
              ),
            ),
          ),
        ]),
      );
    });
  }
}

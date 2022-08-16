import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Providers/UserViewModel.dart';

class WeeklyCounts extends StatefulWidget {
  const WeeklyCounts({Key? key}) : super(key: key);

  @override
  State<WeeklyCounts> createState() => _WeeklyCountsState();
}

class _WeeklyCountsState extends State<WeeklyCounts> {
  final DateFormat formatter = DateFormat('MM-dd-yyyy');
  Map<DateTime, int> weeksCounts = {};
  List<DateTime> weeksOrdered = [];

  Widget returnDateFormatted(index) {
    var currentWeek = weeksOrdered[index];

    return ListTile(
      title: Text(formatter.format(currentWeek)),
      trailing: Text(weeksCounts[currentWeek].toString()),
    );
  }

  void updateCounts(Map<dynamic, dynamic> mappedCounts) {
    Map<DateTime, int> tempWeekCounts = {};
    List<DateTime> tempWeeks = [];
    for (var weekCount in mappedCounts.entries) {
      final date = DateTime.parse(weekCount.key);
      tempWeekCounts[date] = weekCount.value;
      tempWeeks.add(date);
    }
    tempWeeks.sort(
      (a, b) => b.compareTo(a),
    );
    setState(() {
      weeksCounts = tempWeekCounts;
      weeksOrdered = tempWeeks;
    });
  }

  @override
  void initState() {
    super.initState();
    var userVM = Provider.of<UserViewModel>(context, listen: false);

    FirebaseDatabase.instance
        .ref('/users/${userVM.currentUser?.uid}/weeks_counts')
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
      child: Column(children: [
        const Padding(
            padding: EdgeInsets.only(top: 10, right: 150),
            child: Text("Week starting with:")),
        Expanded(
          child: ListView.separated(
            itemCount: weeksCounts.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  child: returnDateFormatted(index),
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
  }
}

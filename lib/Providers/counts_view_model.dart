import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CountsViewModel extends ChangeNotifier {
  String uid;
  Map<String, int> itemCounts = {
    'intense_exercise': 0,
    'moderate_exercise': 0,
    'fruits_veggies': 0,
    'whole': 0,
    'processed': 0,
    'ultra_processed': 0
  };
  DatabaseReference db = FirebaseDatabase.instance.ref();
  final DateFormat intoDbFormatter = DateFormat('yyyy-MM-dd');
  final DateFormat uiTimeFormatter = DateFormat('MM-dd-yyyy @ H:m:s');
  Map<DateTime, int> weeksCounts = {};
  List<DateTime> weeksOrdered = [];
  int goal = 0;
  DateTime lastUpdate = DateTime.now();
  bool itemCountsLoaded = false;

  CountsViewModel(this.uid);

  DateTime findLastSaturday() {
    var currentDate = DateTime.now();
    var daysToSubtract = 0;
    switch (currentDate.weekday) {
      case 1:
        daysToSubtract = 2;
        break;
      case 2:
        daysToSubtract = 3;
        break;
      case 3:
        daysToSubtract = 4;
        break;
      case 4:
        daysToSubtract = 5;
        break;
      case 5:
        daysToSubtract = 6;
        break;
      case 7:
        daysToSubtract = 1;
        break;
      default:
        break;
    }
    final lastSaturdayWithTime =
        DateTime.now().subtract(Duration(days: 7 + daysToSubtract));
    return DateTime(lastSaturdayWithTime.year, lastSaturdayWithTime.month,
        lastSaturdayWithTime.day);
  }

  int getTotal() {
    var total = itemCounts.values.reduce((value, element) => value + element);
    return total;
  }

  String getLastUpdate() {
    var lastUpdateString = uiTimeFormatter.format(lastUpdate);
    return lastUpdateString;
  }

  String getTotalAndGoal() {
    var total = getTotal();
    return "$total / $goal";
  }

  void updateCounts(Map<dynamic, dynamic> mappedCounts) {
    for (var nameAndCount in mappedCounts.entries) {
      if (itemCounts.containsKey(nameAndCount.key)) {
        itemCounts[nameAndCount.key] = nameAndCount.value;
      }
    }

    itemCountsLoaded = true;
    notifyListeners();
  }

  void updateGoal(int newGoal) {
    goal = newGoal;
    notifyListeners();
  }

  void updateLastUpdate(String newDate) {
    lastUpdate = DateTime.parse(newDate);
    notifyListeners();
  }

  void startNewWeek(int newGoal) {
    var beginningSaturday = DateTime.now();
    if (weeksOrdered.isEmpty) {
      beginningSaturday = findLastSaturday();
    } else {
      beginningSaturday = weeksOrdered[0].add(const Duration(days: 7));
    }

    db
        .child(
            '/users/$uid/weeks_counts/${intoDbFormatter.format(beginningSaturday)}')
        .set(getTotal());

    db.child('/users/$uid/counts/breakfast').set({
      "fruits_veggies": 0,
      "intense_exercise": 0,
      "moderate_exercise": 0,
      "processed": 0,
      "ultra_processed": 0,
      "whole": 0
    });

    db.child('/users/$uid/goal').set(newGoal);
  }

  Widget returnDateFormatted(index) {
    var currentWeek = weeksOrdered[index];

    return ListTile(
      title: Text(intoDbFormatter.format(currentWeek)),
      trailing: Text(weeksCounts[currentWeek].toString()),
    );
  }

  void updateWeeklyCounts(Map<dynamic, dynamic> mappedCounts) {
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
    weeksCounts = tempWeekCounts;
    weeksOrdered = tempWeeks;

    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:old_ephraim_app/Views/weekly_counts.dart';

import 'daily_counts.dart';

class TabView extends StatefulWidget {
  const TabView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.assignment)),
              Tab(icon: Icon(Icons.calendar_today)),
            ],
          ),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: const TabBarView(
          children: [
            DailyCounts(),
            WeeklyCounts(),
          ],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

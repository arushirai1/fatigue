import 'dart:ffi';

import 'package:flutter/material.dart';
import 'bar_chart.dart';

// class PricePoint {
//   double x;
//   double y;

//   PricePoint(this.x, this.y);
// }
class DateRangeFilter extends StatefulWidget {
  @override
  _DateRangeFilterState createState() => _DateRangeFilterState();
}

class _DateRangeFilterState extends State<DateRangeFilter> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStart ? startDate ?? DateTime.now() : endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != (isStart ? startDate : endDate))
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _selectDate(context, true),
              child: Text(startDate == null
                  ? 'Select Start Date'
                  : startDate.toString().substring(0, 10)),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _selectDate(context, false),
              child: Text(endDate == null
                  ? 'Select End Date'
                  : endDate.toString().substring(0, 10)),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            // Add logic to filter the chart data based on selected date range
            // For example, you can use a callback or a state management solution to update the chart
            print("woo");
          },
          child: Text('Apply Filter'),
        ),
        // Add your chart widget here
        // Example: BarChartWidget(data: filteredData),
      ],
    );
  }
}

class report extends StatefulWidget {
  @override
  _reportState createState() => _reportState();
}

class _reportState extends State<report> {
  Map<String, dynamic> userSelections = {};
  final List<PricePoint> points = [
    PricePoint(0.0, 97),
    PricePoint(1.0, 74.33),
    PricePoint(2.0, 74.2)
  ];
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0), // Adjust padding as needed
        color: Colors.white, // Sets the background color to white
        // Applies padding uniformly on all sides
        child: Scaffold(
            appBar: AppBar(
              title: Text('Report Screen'),
            ),
            body: Center(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                  Text('Select Date', textScaleFactor: 2),
                  DateRangeFilter(),
                  Center(child: Text('Reaction Time (s) vs Time of Day')),
                  BarChartWidget(points: [
                    PricePoint(0.0, 97.0),
                    PricePoint(1.0, 74.33),
                    PricePoint(2.0, 74.2)
                  ]),
                  Text(
                      "In the mornings you appear to have a slower reaction time, try a morning routine with fruits and lots of water!"),
                  Center(
                      child: Text(
                          'Here\'s some AI generated suggestions for you!',
                          textScaleFactor: 2)),
                  Text(
                      "Aim for 7-8 hours of sleep to feel energetic and focused."),
                  Text(
                      "On less sleep, you tend to feel tired; prioritize rest for better days."),
                  Text(
                      "Higher attention and mood noted with good sleep; make it a habit!"),
                ])))));
  }
}

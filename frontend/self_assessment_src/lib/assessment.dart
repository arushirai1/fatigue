// ignore_for_file: constant_identifier_names, use_key_in_widget_constructors, unused_element, unnecessary_null_comparison, avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_test_application/my_flutter_app_icons.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class assessment extends StatefulWidget {
  @override
  _assessmentState createState() => _assessmentState();
}

class _assessmentState extends State<assessment> {
  Map<String, dynamic> userSelections = {};

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self Assessment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [

            const Text( // energy levels
              'Select your energy level:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            buildScrollableRowOfIcons( 
              ['Exhausted', 'Tired', '   OK   ', 'Energetic', 'Fully Energized'],
              [MyFlutterApp.exhausted, MyFlutterApp.tired, MyFlutterApp.ok, 
              MyFlutterApp.energy, MyFlutterApp.fully],
            ),

             const Text( // physival symptoms
              '\nSelect your physical sympyoms:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            buildScrollableRowOfIcons(
              ['Headache', 'Muscle Ache', 'Gastro', 'None'],
              [MyFlutterApp.tired, MyFlutterApp.ache, 
              MyFlutterApp.gastro, MyFlutterApp.no],
            ),

             const Text( // mental and emotional state (17 choices)
              '\nSelect your mental and emotional state:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            buildScrollableRowOfIcons(
              ['Mood Swings', ' Happy ', '  Sad  ', 
              ' Angry ', 'Excited', 'Anxious', 'Indifferent', 
              'Forgetful', ' Calm ', 'Stressed', 'Distracted', 
              'Motivated', 'Unmotivated'],
              [MyFlutterApp.mood, MyFlutterApp.happy, MyFlutterApp.sad,
               MyFlutterApp.angry, MyFlutterApp.excited, MyFlutterApp.anxious, 
               MyFlutterApp.indifferent, MyFlutterApp.forget, MyFlutterApp.calm, MyFlutterApp.stress,
               MyFlutterApp.distracted, MyFlutterApp.motivated, MyFlutterApp.unmotivated],
            ),

             const Text( //sleep quality
              '\nDid you face insomnia, frequent awakenings, or restless sleep?',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            buildScrollableRowOfIcons(
              ['    Yes    ', '    No    '],
              [MyFlutterApp.yes, MyFlutterApp.no],
            ),

            const SizedBox(height: 20.0), // hours slept
            ElevatedButton(
              onPressed: () {
                _showInputDialog(context);
              },
              child: const Text('Enter how many hours you slept'),
            ),

            const SizedBox(height: 20.0), // start time of shift
            ElevatedButton(
              onPressed: () {
                _showDateTimeDialog(context);
              },
              child: const Text('Enter the start time of your shift'),
            ),

            const SizedBox(height: 20.0), // end time of shift
            ElevatedButton(
              onPressed: () {
                _showDateTimeDialog(context);
              },
              child: const Text('Enter the end time of your shift'),
            ),

           const SizedBox(height: 20.0), // enter user text
            ElevatedButton(
              onPressed: () {
                _showInputDialog(context);
              },
              child: const Text('Enter anything else you would like to document'),
            ),

            const SizedBox(height: 20.0), //submit button
            ElevatedButton(
              onPressed: () {
                _printUserSelections();
              },
              child: const Text('Submit'),
            ),
    
          ],
        ),
      ),
    );
  }

    Widget buildScrollableRowOfIcons(List<String> labels, List<IconData> icons) {
    assert(labels.length == icons.length);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          labels.length,
          (index) => buildClickableIcon(labels[index], icons[index], () {
            // print('${labels[index]} clicked');
            // Store the selection when an icon is clicked
            userSelections[labels[index]] = 'Selected';
            setState(() {}); // Update the UI
          }),
        ),
      ),
    );
  }

Widget buildClickableIcon(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40.0,
              color: Colors.blue,
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }



 Future<void> _showIntegerInputDialog(BuildContext context) async {
    TextEditingController _intTextController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Hours Slept'),
          content: TextField(
            controller: _intTextController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Enter a number'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                int enteredInteger = int.tryParse(_intTextController.text) ?? 0;
                // Store the entered integer when the "OK" button is pressed
                userSelections['Hours Slept'] = enteredInteger;
                setState(() {}); // Update the UI
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

DateTime updateDateTimeWithTimeOfDay(DateTime dateTime, TimeOfDay timeOfDay) {
  // return Timestamp.fromDate(DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour, timeOfDay.minute));
  return DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour, timeOfDay.minute);
}

Future<void> _showDateTimeDialog(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate != null) {
        selectedDate = pickedDate;
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((pickedTime) {
          if (pickedTime != null) {
            selectedTime = pickedTime;

            userSelections['Date and Time Selected'] = updateDateTimeWithTimeOfDay(selectedDate, selectedTime); //'$selectedDate $selectedTime';
            // print(selectedTime);
          //   print('Date and Time Selected: $selectedDate $selectedTime');
         }
        });
      }
    });
  }


 Future<void> _showInputDialog(BuildContext context) async {
    TextEditingController _textController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter anything else you would like to document:'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: 'Enter your text'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String enteredText = _textController.text;
                // Store the entered text when the "OK" button is pressed
              userSelections['Entered Text'] = enteredText;
              setState(() {}); // Update the UI
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
}

   void _submitUserSelections() {
    print('User Selections: $userSelections');
  }
 

  void _printUserSelections() {
    print('User Selections:');
    userSelections.forEach((key, value) {
      print('$key: $value');
    });
  }

}




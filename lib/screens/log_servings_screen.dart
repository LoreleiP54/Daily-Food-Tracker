import 'package:flutter/material.dart';
import '../models/daily_log.dart';
import '../models/food_item.dart';

class LogServingsScreen extends StatefulWidget {
  final FoodItem foodItem;
  final DailyLog dailyLog;

  const LogServingsScreen({
    super.key,
    required this.foodItem,
    required this.dailyLog,
  });

  @override
  State<LogServingsScreen> createState() => _LogServingsScreenState();
}

class _LogServingsScreenState extends State<LogServingsScreen> {
  // the user types the number of servings in here
  TextEditingController servingsController = TextEditingController();

  void logServings() {
    if (servingsController.text == "") {
      print("servings was empty");
      return;
    }

    // convert the text to a number
    double servings = double.parse(servingsController.text);

    // add the entry to todays log
    widget.dailyLog.addEntry(widget.foodItem, servings);

    // go back to the home screen
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Log Servings")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // show the food name at the top
            Text(
              widget.foodItem.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // show the nutrition info per serving so the user knows what they are logging
            Text(
              "Calories per serving: " +
                  widget.foodItem.caloriesPerServing.toString(),
            ),
            Text(
              "Protein per serving: " +
                  widget.foodItem.proteinPerServing.toString() +
                  "g",
            ),
            Text(
              "Carbs per serving: " +
                  widget.foodItem.carbsPerServing.toString() +
                  "g",
            ),
            Text(
              "Fat per serving: " +
                  widget.foodItem.fatPerServing.toString() +
                  "g",
            ),
            SizedBox(height: 20),
            TextField(
              controller: servingsController,
              decoration: InputDecoration(labelText: "Number of Servings"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: logServings,
              child: Text("Add to Todays Log"),
            ),
          ],
        ),
      ),
    );
  }
}

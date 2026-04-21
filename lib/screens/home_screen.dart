import 'package:flutter/material.dart';
import '../models/daily_log.dart';
import '../models/food_item.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // this holds everything the user ate today
  DailyLog dailyLog = DailyLog();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Nutrition Tracker"),
      ),
      body: Column(
        children: [
          // show the totals at the top of the screen
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Todays Totals:", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("Calories: " + dailyLog.totalCalories.toString()),
                Text("Protein: " + dailyLog.totalProtein.toString() + "g"),
                Text("Carbs: " + dailyLog.totalCarbs.toString() + "g"),
                Text("Fat: " + dailyLog.totalFat.toString() + "g"),
              ],
            ),
          ),
          // list of all food items logged today
          Expanded(
            child: ListView.builder(
              itemCount: dailyLog.entries.length,
              itemBuilder: (context, index) {
                // get the current food entry
                LogEntry entry = dailyLog.entries[index];
                return ListTile(
                  title: Text(entry.foodItem.name),
                  subtitle: Text("Servings: " + entry.servings.toString()),
                );
              },
            ),
          ),
        ],
      ),
      // button to add food, navigation not hooked up yet
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("add food pressed"); // will replace with navigation later but not today
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/daily_log.dart';
import '../models/food_item.dart';
import '../models/food_library.dart';
import 'food_library_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // this holds everything the user ate today
  DailyLog dailyLog = DailyLog();

  // this holds all the saved food items the user has created
  FoodLibrary foodLibrary = FoodLibrary();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daily Nutrition Tracker")),
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
      // button to go to the food library screen
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // wait for the user to come back, then refresh the totals
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodLibraryScreen(
                foodLibrary: foodLibrary,
                dailyLog: dailyLog,
              ),
            ),
          );
          // rebuild so the new totals and entries show up
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

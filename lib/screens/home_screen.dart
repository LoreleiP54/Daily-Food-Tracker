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
      appBar: AppBar(
        title: const Text(
          "Daily Nutrition Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // show the totals at the top of the screen
          Card(
            elevation: 2,
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Totals",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 24, thickness: 1),
                  // Using a helper method or repetitive rows for clean alignment, at bottom of this file
                  _buildStatRow("Calories", dailyLog.totalCalories.toString()),
                  _buildStatRow("Protein", "${dailyLog.totalProtein}g"),
                  _buildStatRow("Carbs", "${dailyLog.totalCarbs}g"),
                  _buildStatRow("Fat", "${dailyLog.totalFat}g"),
                ],
              ),
            ),
          ),

          // list of all food items logged today
          Expanded(
            child: dailyLog.entries.isEmpty
                // show a message if nothing has been logged yet
                ? Center(
                    child: Text("No food logged yet. Press + to add food."),
                  )
                : ListView.builder(
                    itemCount: dailyLog.entries.length,
                    itemBuilder: (context, index) {
                      // get the current food entry
                      LogEntry entry = dailyLog.entries[index];
                      // wrap in Dismissible so the user can swipe to delete
                      return Dismissible(
                        key: Key(index.toString()), // needs a unique key
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          // remove the entry and refresh the totals
                          setState(() {
                            dailyLog.removeEntry(index);
                          });
                        },
                        child: Card(
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            title: Text(
                              entry.foodItem.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text("Servings: ${entry.servings}"),
                            // Visual cue: hints that there is more "to the right"
                            trailing: Icon(
                              Icons.chevron_left,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // button to go to the food library screen
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodLibraryScreen(
                foodLibrary: foodLibrary,
                dailyLog: dailyLog,
              ),
            ),
          );
          setState(() {});
        },
        label: const Text("Add Food"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

Widget _buildStatRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 16)),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    ),
  );
}

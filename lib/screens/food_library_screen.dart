import 'package:flutter/material.dart';
import '../models/daily_log.dart';
import '../models/food_item.dart';
import '../models/food_library.dart';
import 'add_food_screen.dart';
import 'log_servings_screen.dart';

class FoodLibraryScreen extends StatefulWidget {
  // we pass the library in so the home screen can share the same one
  final FoodLibrary foodLibrary;

  // we also need the daily log so we can add entries from here
  final DailyLog dailyLog;

  const FoodLibraryScreen({
    super.key,
    required this.foodLibrary,
    required this.dailyLog,
  });

  @override
  State<FoodLibraryScreen> createState() => _FoodLibraryScreenState();
}

class _FoodLibraryScreenState extends State<FoodLibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Foods")),
      body: widget.foodLibrary.numberOfFoods == 0
          // show a message if the library is empty
          ? Center(child: Text("No foods saved yet. Press + to add one."))
          : ListView.builder(
              itemCount: widget.foodLibrary.numberOfFoods,
              itemBuilder: (context, index) {
                // grab each food from the library
                FoodItem food = widget.foodLibrary.getFood(index);
                return ListTile(
                  title: Text(food.name),
                  // show summary of calories per serving
                  subtitle: Text(
                    "Calories per serving: " +
                        food.caloriesPerServing.toString(),
                  ),
                  // tap a food to log servings of it
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogServingsScreen(
                          foodItem: food,
                          dailyLog: widget.dailyLog,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      // button to add a new food item to the library
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddFoodScreen(foodLibrary: widget.foodLibrary),
            ),
          );
          // rebuild so the new food shows up in the list
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

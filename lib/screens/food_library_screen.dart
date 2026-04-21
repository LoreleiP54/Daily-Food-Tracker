import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/food_library.dart';

class FoodLibraryScreen extends StatefulWidget {
  // we pass the library in so the home screen can share the same one
  final FoodLibrary foodLibrary;

  const FoodLibraryScreen({super.key, required this.foodLibrary});

  @override
  State<FoodLibraryScreen> createState() => _FoodLibraryScreenState();
}

class _FoodLibraryScreenState extends State<FoodLibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Foods")),
      body: ListView.builder(
        itemCount: widget.foodLibrary.numberOfFoods,
        itemBuilder: (context, index) {
          // grab each food from the library
          FoodItem food = widget.foodLibrary.getFood(index);
          return ListTile(
            title: Text(food.name),
            // show summary of calories per serving
            subtitle: Text(
              "Calories per serving: " + food.caloriesPerServing.toString(),
            ),
          );
        },
      ),
      // button to add a new food item to the library
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(
            "add new food pressed",
          ); // will replace with navigation later but not today
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

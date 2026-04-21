import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/food_library.dart';

class AddFoodScreen extends StatefulWidget {
  final FoodLibrary foodLibrary;

  const AddFoodScreen({super.key, required this.foodLibrary});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  // one controller for each text field
  TextEditingController nameController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController fatController = TextEditingController();

  void saveFood() {
    if (nameController.text == "") {
      print("name was empty, not saving");
      return;
    }

    // convert the text inputs to numbers
    double calories = double.parse(caloriesController.text);
    double protein = double.parse(proteinController.text);
    double carbs = double.parse(carbsController.text);
    double fat = double.parse(fatController.text);

    // create the new food item and add it to the library
    FoodItem newFood = FoodItem(
      name: nameController.text,
      caloriesPerServing: calories,
      proteinPerServing: protein,
      carbsPerServing: carbs,
      fatPerServing: fat,
    );

    widget.foodLibrary.addFood(newFood);

    // go back to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Food")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Food Name"),
            ),
            TextField(
              controller: caloriesController,
              decoration: InputDecoration(labelText: "Calories per Serving"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: proteinController,
              decoration: InputDecoration(labelText: "Protein (g)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: carbsController,
              decoration: InputDecoration(labelText: "Carbs (g)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: fatController,
              decoration: InputDecoration(labelText: "Fat (g)"),
              keyboardType: TextInputType.number,
            ),
            // some space before the button
            SizedBox(height: 20),
            ElevatedButton(onPressed: saveFood, child: Text("Save Food")),
          ],
        ),
      ),
    );
  }
}

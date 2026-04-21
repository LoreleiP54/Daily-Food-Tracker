import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/food_item.dart';

class NutritionProvider with ChangeNotifier {
  List<FoodItem> _dailyLog = [];
  List<FoodItem> _savedFoods = [];

  List<FoodItem> get dailyLog => _dailyLog;
  List<FoodItem> get savedFoods => _savedFoods;

  NutritionProvider() {
    loadData();
  }

  double get totalDailyCalories =>
      _dailyLog.fold(0, (sum, item) => sum + (item.calories * item.servings));
  double get totalDailyProtein =>
      _dailyLog.fold(0, (sum, item) => sum + (item.protein * item.servings));

  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final logData = json.encode(_dailyLog.map((item) => item.toMap()).toList());
    final libraryData = json.encode(
      _savedFoods.map((item) => item.toMap()).toList(),
    );

    await prefs.setString('daily_log', logData);
    await prefs.setString('food_library', libraryData);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('daily_log')) {
      final List<dynamic> extractedLog = json.decode(
        prefs.getString('daily_log')!,
      );
      _dailyLog = extractedLog.map((item) => FoodItem.fromMap(item)).toList();
    }

    if (prefs.containsKey('food_library')) {
      final List<dynamic> extractedLib = json.decode(
        prefs.getString('food_library')!,
      );
      _savedFoods = extractedLib.map((item) => FoodItem.fromMap(item)).toList();
    }
    notifyListeners();
  }

  void saveAndLogFood(FoodItem food) {
    if (!_savedFoods.any((item) => item.name == food.name)) {
      _savedFoods.add(food);
    }
    _dailyLog.add(food);
    _saveToDisk();
    notifyListeners();
  }

  void addSavedFoodToLog(FoodItem food, double newServings) {
    final logEntry = FoodItem(
      id: DateTime.now().toString(),
      name: food.name,
      calories: food.calories,
      protein: food.protein,
      servings: newServings,
    );
    _dailyLog.add(logEntry);
    _saveToDisk();
    notifyListeners();
  }

  void addFoodToLibrary(String name, double calories, double protein) {
    final newItem = FoodItem(
      id: DateTime.now().toString(),
      name: name,
      calories: calories,
      protein: protein,
      servings: 1.0,
    );
    _savedFoods.add(newItem);
    _saveToDisk();
    notifyListeners();
  }

  void logConsumption(FoodItem baseFood, double servings) {
    final logEntry = FoodItem(
      id: DateTime.now().toString(),
      name: baseFood.name,
      calories: baseFood.calories,
      protein: baseFood.protein,
      servings: servings,
    );
    _dailyLog.add(logEntry);
    _saveToDisk();
    notifyListeners();
  }
}

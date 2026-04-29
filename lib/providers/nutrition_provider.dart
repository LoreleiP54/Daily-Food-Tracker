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
  static int _idCounter = 0;
  String _generateId() => '${++_idCounter}';

  double get totalDailyCalories =>
      _dailyLog.fold(0, (sum, item) => sum + (item.calories * item.servings));
  double get totalDailyProtein =>
      _dailyLog.fold(0, (sum, item) => sum + (item.protein * item.servings));
  double get totalDailyFat =>
      _dailyLog.fold(0, (sum, item) => sum + (item.fat * item.servings));
  double get totalDailyCarbs =>
      _dailyLog.fold(0, (sum, item) => sum + (item.carbs * item.servings));
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
      id: _generateId(),
      name: food.name,
      calories: food.calories,
      protein: food.protein,
      fat: food.fat,
      carbs: food.carbs,
      servings: newServings,
      loggedDate: DateTime.now(),
    );
    _dailyLog.add(logEntry);
    _saveToDisk();
    notifyListeners();
  }

  void addFoodToLibrary(
    String name,
    double calories,
    double protein,
    double fat,
    double carbs,
  ) {
    final newItem = FoodItem(
      id: _generateId(),
      name: name,
      calories: calories,
      protein: protein,
      fat: fat,
      carbs: carbs,
      servings: 1.0,
      loggedDate: DateTime.now(),
    );
    _savedFoods.add(newItem);
    _saveToDisk();
    notifyListeners();
  }

  void logConsumption(FoodItem baseFood, double servings) {
    final today = DateTime.now();
    final existingIndex = _dailyLog.indexWhere(
      (item) =>
          item.name == baseFood.name &&
          item.loggedDate.year == today.year &&
          item.loggedDate.month == today.month &&
          item.loggedDate.day == today.day,
    );
    if (existingIndex != -1) {
      _dailyLog[existingIndex].servings += servings;
    } else {
      final logEntry = FoodItem(
        id: _generateId(),
        name: baseFood.name,
        calories: baseFood.calories,
        protein: baseFood.protein,
        fat: baseFood.fat,
        carbs: baseFood.carbs,
        servings: servings,
        loggedDate: DateTime.now(),
      );
      _dailyLog.add(logEntry);
    }
    _saveToDisk();
    notifyListeners();
  }

  void removeFromDailyLog(String id) {
    _dailyLog.removeWhere((item) => item.id == id);
    _saveToDisk();
    notifyListeners();
  }

  void updateDailyLogServings(String id, double servings) {
    final index = _dailyLog.indexWhere((item) => item.id == id);
    if (index != -1) {
      _dailyLog[index].servings = servings;
      _saveToDisk();
      notifyListeners();
    }
  }

  void removeFoodFromLibrary(String id) {
    _savedFoods.removeWhere((item) => item.id == id);
    _saveToDisk();
    notifyListeners();
  }

  void updateFoodInLibrary(
    String id,
    String name,
    double calories,
    double protein,
    double fat,
    double carbs,
  ) {
    final index = _savedFoods.indexWhere((item) => item.id == id);
    if (index != -1) {
      _savedFoods[index] = FoodItem(
        id: id,
        name: name,
        calories: calories,
        protein: protein,
        fat: fat,
        carbs: carbs,
        servings: _savedFoods[index].servings,
        loggedDate: DateTime.now(),
      );
      _saveToDisk();
      notifyListeners();
    }
  }

  List<FoodItem> getLogForDay(DateTime day) {
    return _dailyLog
        .where(
          (item) =>
              item.loggedDate.year == day.year &&
              item.loggedDate.month == day.month &&
              item.loggedDate.day == day.day,
        )
        .toList();
  }
}

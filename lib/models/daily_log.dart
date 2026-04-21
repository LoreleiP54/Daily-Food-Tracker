import 'food_item.dart';

class LogEntry {
  final FoodItem foodItem;
  final double servings;

  LogEntry({required this.foodItem, required this.servings});
}

class DailyLog {
  final List<LogEntry> _entries = [];

  List<LogEntry> get entries => List.unmodifiable(_entries);

  void addEntry(FoodItem foodItem, double servings) {
    _entries.add(LogEntry(foodItem: foodItem, servings: servings));
  }

  void removeEntry(int index) {
    _entries.removeAt(index);
  }

  double get totalCalories {
    double total = 0;
    for (int i = 0; i < _entries.length; i++) {
      total =
          total +
          _entries[i].foodItem.caloriesPerServing * _entries[i].servings;
    }
    return total;
  }

  double get totalProtein {
    double total = 0;
    for (int i = 0; i < _entries.length; i++) {
      total =
          total + _entries[i].foodItem.proteinPerServing * _entries[i].servings;
    }
    return total;
  }

  double get totalCarbs {
    double total = 0;
    for (int i = 0; i < _entries.length; i++) {
      total =
          total + _entries[i].foodItem.carbsPerServing * _entries[i].servings;
    }
    return total;
  }

  double get totalFat {
    double total = 0;
    for (int i = 0; i < _entries.length; i++) {
      total = total + _entries[i].foodItem.fatPerServing * _entries[i].servings;
    }
    return total;
  }
}

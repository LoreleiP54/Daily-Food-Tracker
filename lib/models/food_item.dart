class FoodItem {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final DateTime loggedDate;

  double servings;
  double totalCalories;
  double totalProtein;
  double totalFat;
  double totalCarbs;

  FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.loggedDate,
    this.servings = 1.0,
    this.totalCalories = 0,
    this.totalProtein = 0,
    this.totalFat = 0,
    this.totalCarbs = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'servings': servings,
      'loggedDate': loggedDate.toIso8601String(),
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      calories: map['calories'],
      protein: map['protein'],
      fat: map['fat'],
      carbs: map['carbs'],
      servings: map['servings'],
      loggedDate: DateTime.parse(map['loggedDate']),
    );
  }
}

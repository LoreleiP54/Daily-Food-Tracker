class FoodItem {
  final String id;
  final String name;
  final double calories; 
  final double protein;  // tentative limited nutrition info, ideally would be all posssible information but could easily be overkill
  double servings;
  double totalCalories;
  double totalProtein;

  FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    this.servings = 1.0,
    this.totalCalories = 0,
    this.totalProtein = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'servings': servings,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      calories: map['calories'],
      protein: map['protein'],
      servings: map['servings'],
    );
  }
}
import 'food_item.dart';

class FoodLibrary {
  List<FoodItem> savedFoods = [];

  void addFood(FoodItem food) {
    savedFoods.add(food);
  }

  void removeFood(int index) {
    savedFoods.removeAt(index);
  }

  FoodItem getFood(int index) {
    return savedFoods[index];
  }

  int get numberOfFoods {
    return savedFoods.length;
  }
}

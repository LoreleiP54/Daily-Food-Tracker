import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/nutrition_provider.dart';
import '../models/food_item.dart';

class LogIntakeScreen extends StatelessWidget {
  const LogIntakeScreen({super.key});

  void _showServingsDialog(BuildContext context, FoodItem food) {
    final TextEditingController servingsController = TextEditingController(
      text: "1.0",
    );

    showDialog(
      context: context,
      builder: (buildContext) => AlertDialog(
        title: Text(food.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${food.calories.toStringAsFixed(0)} Cal per serving'),
            Text('${food.protein.toStringAsFixed(1)}g protein '),
            Text('${food.fat.toStringAsFixed(1)}g fat '),
            Text('${food.carbs.toStringAsFixed(1)}g carbs '),
            const SizedBox(height: 15),
            TextField(
              controller: servingsController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Number of Servings',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(buildContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final double servings =
                  double.tryParse(servingsController.text) ?? 1.0;

              Provider.of<NutritionProvider>(
                context,
                listen: false,
              ).logConsumption(food, servings);

              Navigator.pop(buildContext);
              Navigator.pop(context);
            },
            child: const Text('Add to Daily Log'),
          ),
        ],
      ),
    );
  }

  void _showEditLibraryItemDialog(BuildContext context, FoodItem food) {
    final nameController = TextEditingController(text: food.name);
    final calController = TextEditingController(text: food.calories.toString());
    final proController = TextEditingController(text: food.protein.toString());
    final fatController = TextEditingController(text: food.fat.toString());
    final carbController = TextEditingController(text: food.carbs.toString());
    showDialog(
      context: context,
      builder: (buildContext) => AlertDialog(
        title: const Text('Edit Food'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Food Name'),
              ),
              TextField(
                controller: calController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calories per serving',
                ),
              ),
              TextField(
                controller: proController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Protein per serving (g)',
                ),
              ),
              TextField(
                controller: fatController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Fat per serving (g)',
                ),
              ),
              TextField(
                controller: carbController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Carbs per serving (g)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(buildContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final calories = double.tryParse(calController.text);
              final protein = double.tryParse(proController.text);
              final fat = double.tryParse(fatController.text);
              final carbs = double.tryParse(carbController.text);
              if (name.isNotEmpty &&
                  calories != null &&
                  protein != null &&
                  fat != null &&
                  carbs != null) {
                Provider.of<NutritionProvider>(
                  context,
                  listen: false,
                ).updateFoodInLibrary(
                  food.id,
                  name,
                  calories,
                  protein,
                  fat,
                  carbs,
                );
              }
              Navigator.pop(buildContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) {
      nameController.dispose();
      calController.dispose();
      proController.dispose();
      fatController.dispose();
      carbController.dispose();
    });
  }

  void _confirmDeleteLibraryItem(BuildContext context, FoodItem food) {
    showDialog(
      context: context,
      builder: (buildContext) => AlertDialog(
        title: const Text('Delete Food'),
        content: Text('Remove "${food.name}" from the library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(buildContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Provider.of<NutritionProvider>(
                context,
                listen: false,
              ).removeFoodFromLibrary(food.id);
              Navigator.pop(buildContext);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nutritionProvider = Provider.of<NutritionProvider>(context);
    final List<FoodItem> library = nutritionProvider.savedFoods;

    return Scaffold(
      appBar: AppBar(title: const Text('Log Food Intake')),
      body: library.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.no_food, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Food library is empty.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Add food definitions in the "Create Food" screen first.',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/add-food'),
                    child: const Text('Go to Create Food'),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: library.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (buildContext, i) {
                final food = library[i];
                return ListTile(
                  title: Text(
                    food.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${food.calories.toStringAsFixed(0)} Cal | ${food.protein}g Protein | ${food.fat}g Fat | ${food.carbs}g Carbs',
                  ),
                  onTap: () => _showServingsDialog(context, food),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditLibraryItemDialog(context, food);
                      } else if (value == 'delete') {
                        _confirmDeleteLibraryItem(context, food);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

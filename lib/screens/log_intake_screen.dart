import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/nutrition_provider.dart';
import '../models/food_item.dart';

class LogIntakeScreen extends StatelessWidget {
  const LogIntakeScreen({super.key});

  void _showServingsDialog(BuildContext context, FoodItem food) {
    final TextEditingController servingsController = TextEditingController(text: "1.0");

    showDialog(
      context: context,
      builder: (buildContext) => AlertDialog(
        title: Text(food.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${food.calories.toStringAsFixed(0)} Cal per serving'),
            Text('${food.protein.toStringAsFixed(0)} g of protein per serving'),
            const SizedBox(height: 15),
            TextField(
              controller: servingsController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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

              final double servings = double.tryParse(servingsController.text) ?? 1.0;
              
              Provider.of<NutritionProvider>(context, listen: false)
                  .logConsumption(food, servings);

              Navigator.pop(buildContext);
              Navigator.pop(context);
              
            },
            child: const Text('Add to Daily Log'),
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
      appBar: AppBar(
        title: const Text('Log Food Intake'),
      ),
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
                  const Text('Add food definitions in the "Create Food" screen first.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/create-food'),
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
                  title: Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${food.calories.toStringAsFixed(0)} Cal | ${food.protein}g Protein'),
                  onTap: () => _showServingsDialog(context, food),
                );
              },
            ),
    );
  }
}
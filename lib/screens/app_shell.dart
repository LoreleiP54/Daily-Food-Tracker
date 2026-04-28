import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/nutrition_provider.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final nutrition = Provider.of<NutritionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Food Tracker'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSummaryCard(nutrition),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Food Consumed",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: nutrition.dailyLog.isEmpty
                ? const Center(child: Text("No food logged for today yet."))
                : ListView.builder(
                    itemCount: nutrition.dailyLog.length,
                    itemBuilder: (context, i) {
                      final item = nutrition.dailyLog[i];
                      return Dismissible(
                        key: Key(item.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => Provider.of<NutritionProvider>(
                          context,
                          listen: false,
                        ).removeFromDailyLog(item.id),
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text('${item.servings} servings'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${(item.calories * item.servings).toStringAsFixed(0)} Cal',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () =>
                                    _showEditServingsDialog(context, item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          _buildActionPanel(context),
        ],
      ),
    );
  }

  void _showEditServingsDialog(BuildContext context, FoodItem item) {
    final controller = TextEditingController(text: item.servings.toString());
    showDialog(
      context: context,
      builder: (buildContext) => AlertDialog(
        title: Text('Edit ${item.name}'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Number of Servings',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(buildContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final servings = double.tryParse(controller.text);
              if (servings != null && servings > 0) {
                Provider.of<NutritionProvider>(
                  context,
                  listen: false,
                ).updateDailyLogServings(item.id, servings);
              }
              Navigator.pop(buildContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/add-food'),
              icon: const Icon(Icons.library_add),
              label: const Text('New Food Info'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/log-intake'),
              icon: const Icon(Icons.add_box),
              label: const Text('Log a Meal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(NutritionProvider nutrition) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCell(
                    'Calories',
                    nutrition.totalDailyCalories.toStringAsFixed(0),
                  ),
                ),
                Container(width: 1, height: 50, color: Colors.grey[300]),
                Expanded(
                  child: _buildStatCell(
                    'Protein (g)',
                    nutrition.totalDailyProtein.toStringAsFixed(1),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatCell(
                    'Fat (g)',
                    nutrition.totalDailyFat.toStringAsFixed(1),
                  ),
                ),
                Container(width: 1, height: 50, color: Colors.grey[300]),
                Expanded(
                  child: _buildStatCell(
                    'Carbs (g)',
                    nutrition.totalDailyCarbs.toStringAsFixed(1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCell(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

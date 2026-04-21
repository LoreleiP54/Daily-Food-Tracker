import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('${item.servings} servings'),
                        trailing: Text(
                          '${(item.calories * item.servings).toStringAsFixed(0)} Cal',
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text('Daily Calories', style: TextStyle(color: Colors.grey)),
                Text(
                  nutrition.totalDailyCalories.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            Container(width: 1, height: 40, color: Colors.grey[300]),
            Column(
              children: [
                const Text('Daily Protein (g)', style: TextStyle(color: Colors.grey)),
                Text(
                  nutrition.totalDailyProtein.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
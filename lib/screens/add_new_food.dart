import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/nutrition_provider.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _nameController = TextEditingController();
  final _calController = TextEditingController();
  final _proController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Food Definition')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Food Name'),
            ),
            TextField(
              controller: _calController,
              decoration: const InputDecoration(
                labelText: 'Calories per serving',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _proController,
              decoration: const InputDecoration(
                labelText: 'Protein per serving',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<NutritionProvider>(
                  context,
                  listen: false,
                ).addFoodToLibrary(
                  _nameController.text,
                  double.parse(_calController.text),
                  double.parse(_proController.text),
                );
                Navigator.pop(context);
              },
              child: const Text('Save to Library'),
            ),
          ],
        ),
      ),
    );
  }
}

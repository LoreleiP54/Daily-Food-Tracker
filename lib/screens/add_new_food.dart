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
  void dispose() {
    _nameController.dispose();
    _calController.dispose();
    _proController.dispose();
    super.dispose();
  }

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
                final name = _nameController.text.trim();
                final calories = double.tryParse(_calController.text);
                final protein = double.tryParse(_proController.text);

                if (name.isEmpty || calories == null || protein == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter a valid name, calories, and protein.',
                      ),
                    ),
                  );
                  return;
                }

                Provider.of<NutritionProvider>(
                  context,
                  listen: false,
                ).addFoodToLibrary(name, calories, protein);
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/nutrition_provider.dart';
import 'screens/app_shell.dart';
import 'screens/add_new_food.dart';
import 'screens/log_intake_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NutritionProvider(),
      child: const FoodTrackerApp(),
    ),
  );
}

class FoodTrackerApp extends StatelessWidget {
  const FoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Food Tracker',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/',
      routes: {
        '/': (context) => const AppShell(),
        '/add-food': (context) => const AddFoodScreen(),
        '/log-intake': (context) => const LogIntakeScreen(),
      },
    );
  }
}
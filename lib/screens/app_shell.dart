import 'package:flutter/material.dart';
import '../screens/log_intake_screen.dart';
import '../screens/add_new_food.dart';
import '../screens/home_screen.dart';
import '../screens/calendar_screen.dart';
// ─── App Shell (tab controller) ─────────────────────────────────────────────

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  void _switchTab(int index) {
    setState(() => _selectedIndex = index);
  }

  List<Widget> get _screens => [
    const HomeScreen(),
    LogIntakeScreen(onSwitchTab: _switchTab),
    const CalendarScreen(),
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Nutrition Tracker'),
        centerTitle: true,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Log Meal'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Calendar',
          ),
        ],
      ),
    );
  }
}

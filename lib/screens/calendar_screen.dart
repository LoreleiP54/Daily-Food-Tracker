import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/nutrition_provider.dart';
import '../models/food_item.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final nutrition = Provider.of<NutritionProvider>(context);
    final selectedLog = nutrition.getLogForDay(_selectedDay);

    final totalCals = selectedLog.fold<double>(
        0, (sum, item) => sum + (item.calories * item.servings));
    final totalProtein = selectedLog.fold<double>(
        0, (sum, item) => sum + (item.protein * item.servings));
    final totalFat = selectedLog.fold<double>(
        0, (sum, item) => sum + (item.fat * item.servings));
    final totalCarbs = selectedLog.fold<double>(
        0, (sum, item) => sum + (item.carbs * item.servings));

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: const {CalendarFormat.month: 'Month'},
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              final hasLog = nutrition.getLogForDay(day).isNotEmpty;
              if (!hasLog) return const SizedBox.shrink();
              return Positioned(
                bottom: 4,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
          calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.black12,
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(color: Colors.black),
            weekendTextStyle: TextStyle(color: Colors.red),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(fontSize: 16),
          ),
        ),
        const Divider(height: 1),
        if (selectedLog.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                'Nothing logged for this day.',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
          )
        else ...[
          _buildDaySummaryCard(totalCals, totalProtein, totalFat, totalCarbs),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Foods consumed',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: selectedLog.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) => _buildFoodTile(selectedLog[i]),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDaySummaryCard(
      double cals, double protein, double fat, double carbs) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatCell('Calories', cals.toStringAsFixed(0))),
          Expanded(child: _buildStatCell('Protein', '${protein.toStringAsFixed(1)}g')),
          Expanded(child: _buildStatCell('Fat', '${fat.toStringAsFixed(1)}g')),
          Expanded(child: _buildStatCell('Carbs', '${carbs.toStringAsFixed(1)}g')),
        ],
      ),
    );
  }

  Widget _buildStatCell(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildFoodTile(FoodItem item) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      title: Text(item.name),
      subtitle: Text(
        '${item.servings} ${'servings'}',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: Text(
        '${(item.calories * item.servings).toStringAsFixed(0)} Cal',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
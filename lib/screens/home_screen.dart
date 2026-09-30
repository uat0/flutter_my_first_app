import 'package:flutter/material.dart';

import '../widgets.dart';
import 'calculator_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  int _historyVersion = 0; // меняется после расчёта → профиль перезагрузит историю

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          CalculatorScreen(onSaved: () => setState(() => _historyVersion++)),
          ProfileScreen(key: ValueKey(_historyVersion)),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        index: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

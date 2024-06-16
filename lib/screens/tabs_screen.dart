import 'package:flutter/material.dart';
import 'package:meals_app/screens/categories_screen.dart';
import 'package:meals_app/screens/meals_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedTabIndex = 0;

  void _onTabSelect(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activeTab = const CategoriesScreen();
    String activeTabTitle = "Pick your Category";
    if (_selectedTabIndex == 1) {
      activeTab = const MealsScreen(meals: []);
      activeTabTitle = "Your Favorites";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activeTabTitle),
      ),
      body: activeTab,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          _onTabSelect(index);
        },
        currentIndex: _selectedTabIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

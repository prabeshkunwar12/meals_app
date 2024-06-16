import 'package:flutter/material.dart';
import 'package:meals_app/model/meal.dart';
import 'package:meals_app/screens/categories_screen.dart';
import 'package:meals_app/screens/meals_screen.dart';
import 'package:meals_app/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedTabIndex = 0;
  final List<Meal> _favoritedMeals = [];

  void _onTabSelect(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _onToggleFavoriteMeals(Meal meal) {
    setState(() {
      if (_favoritedMeals.contains(meal)) {
        _favoritedMeals.remove(meal);
        _showInfoMessage("Meal Removed from Favorites");
      } else {
        _favoritedMeals.add(meal);
        _showInfoMessage("Meal Added to Favorites");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activeTab = CategoriesScreen(
      onToggleFavorite: _onToggleFavoriteMeals,
    );
    String activeTabTitle = "Pick your Category";
    if (_selectedTabIndex == 1) {
      activeTab = MealsScreen(
        meals: _favoritedMeals,
        onToggleFavorite: _onToggleFavoriteMeals,
      );
      activeTabTitle = "Your Favorites";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activeTabTitle),
      ),
      drawer: const MainDrawer(),
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

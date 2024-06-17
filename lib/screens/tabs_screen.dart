import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/model/meal.dart';
import 'package:meals_app/screens/categories_screen.dart';
import 'package:meals_app/screens/filter_screen.dart';
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
  Map<Filter, bool> _selectedFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false,
  };

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

  void _onSelectScreen(String identifiers) async {
    Navigator.of(context).pop();
    if (identifiers == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FilterScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );

      setState(() {
        _selectedFilters = result ?? _selectedFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Meal> availableMeals = dummyMeals.where((meal) {
      if ((_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) ||
          (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) ||
          (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) ||
          (_selectedFilters[Filter.vegan]! && !meal.isVegan)) return false;
      return true;
    }).toList();

    Widget activeTab = CategoriesScreen(
      availableMeals: availableMeals,
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
      drawer: MainDrawer(
        onSelectScreen: _onSelectScreen,
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

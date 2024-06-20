import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  void setFilter(Filter filter, bool isActive) {
    // state[filter] = isActive //is not allowed! => mutating state
    state = {
      ...state,
      filter: isActive,
    };
  }

  void setFilters(Map<Filter, bool> modifiedFilters) {
    state = modifiedFilters;
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProviider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if ((activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) ||
        (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) ||
        (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) ||
        (activeFilters[Filter.vegan]! && !meal.isVegan)) return false;
    return true;
  }).toList();
});

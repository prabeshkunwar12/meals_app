import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/model/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal meal) {
    //we cannot directly add or remove from the list
    if (state.contains(meal)) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

/// For dynamic data we use StateNotifierProvider
/// It returns instance of FavoriteMealsNotifier
/// which stores the List of Meal
final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});

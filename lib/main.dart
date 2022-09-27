import 'package:flutter/material.dart';
import 'package:meals_app/screens/favourites_screen.dart';

import './dummy_data.dart';
import '../screens/filters_screen.dart';
import '../screens/tabs_screen.dart';
import './screens/categories_screen.dart';
import './screens/category_meals_screen.dart';
import './screens/meal_detail_screen.dart';
import './models/meal.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ignore: todo
  //TODO: create model from codeblock below
  Map<String, bool> _filters = {
    "gluten": false,
    'lactose': false,
    'vegeterian': false,
    'vegan': false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favouriteMeals = [];

  void setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten'] && !meal.isGlutenFree) {
          return false;
        }

        if (_filters['lactose'] && !meal.isLactoseFree) {
          return false;
        }

        if (_filters['vegeterian'] && !meal.isVegetarian) {
          return false;
        }

        if (_filters['vegan'] && !meal.isVegan) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  void _toggleFavourite(String mealId) {
    final existingIndex =
        _favouriteMeals.indexWhere((meal) => meal.id == mealId);

    (existingIndex >= 0)
        ? setState(() {
            _favouriteMeals.removeAt(existingIndex);
          })
        : setState(() {
            _favouriteMeals.add(
              DUMMY_MEALS.firstWhere((element) => element.id == mealId),
            );
          });
  }

  bool isMealFavourite(String id) {
    return _favouriteMeals.any((element) => element.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
            .copyWith(secondary: Colors.amber),
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            bodyText2: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            headline6: TextStyle(
              fontSize: 20,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            )),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => TabsScreen(_favouriteMeals),
        CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(
            _availableMeals), //get value of routeName, use that as static value (line "home above") and then point to "CategoryMealsScreen"
        MealDetailScreen.routeName: (ctx) =>
            MealDetailScreen(_toggleFavourite, isMealFavourite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters, setFilters),
      },
      // onGenerateRoute: ((settings) { // if routing is generated dynamically
      //   print(settings.arguments);
      //   if (settings.name == '/something-else') {
      //     return ...;
      //   }
      //   return MaterialPageRoute(
      //     builder: (ctx) => CategoriesScreen(),
      //   );
      // }),
      onUnknownRoute: (settings) {
        // similar to a 404
        return MaterialPageRoute(
          builder: (ctx) => CategoriesScreen(),
        );
      },
    );
  }
}

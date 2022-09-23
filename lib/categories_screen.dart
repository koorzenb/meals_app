import 'package:flutter/material.dart';

import './category_item.dart';
import './dummy_data.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      children: DUMMY_CATEGORIES
          .map((element) => CategoryItem(element.title, element.color))
          .toList(),
    );
  }
}
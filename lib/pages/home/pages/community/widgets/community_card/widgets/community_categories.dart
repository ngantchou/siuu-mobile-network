import 'package:Siuu/models/category.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/widgets/category_badge.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBMemoryCategories extends StatelessWidget {
  final Memory memory;

  OBMemoryCategories(this.memory);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: memory,
      stream: memory.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        Memory memory = snapshot.data;
        if (memory.categories == null) return const SizedBox();
        List<Category> categories = memory.categories.categories;

        List<Widget> connectionItems = [];

        categories.forEach((Category category) {
          connectionItems.add(Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OBCategoryBadge(
                category: category,
                size: OBCategoryBadgeSize.small,
              )
            ],
          ));
        });

        return Padding(
          padding: EdgeInsets.only(top: 10),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: connectionItems,
          ),
        );
      },
    );
  }
}

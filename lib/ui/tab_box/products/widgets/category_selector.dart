import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  final List<String> categories;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          TextButton(
            onPressed: () {
              onCategorySelected.call("");
            },
            child: const Text("All"),
          ),
          ...List.generate(categories.length, (index) {
            return TextButton(
              onPressed: () {
                onCategorySelected.call(categories[index]);
              },
              child: Text(
                categories[index],
              ),
            );
          })
        ],
      ),
    );
  }
}

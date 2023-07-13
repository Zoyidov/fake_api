import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  final List<String> categories;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                SizedBox(height: 10,),
                ZoomTapAnimation(
                  onTap: () {
                    onCategorySelected.call("");
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Center(child: const Text("All",style: TextStyle(color: Colors.black),)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(categories.length, (index) {
            return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      ZoomTapAnimation(
                        onTap: () {
                          onCategorySelected.call(categories[index]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Center(child: Text(categories[index],style: TextStyle(color: Colors.black),)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
          },
          ).toList(),
        ],
      ),
    );
  }
}

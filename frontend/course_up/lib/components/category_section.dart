import 'package:flutter/material.dart';
import 'package:course_up/components/category_text.dart';

class CategorySection extends StatelessWidget {
  final Function(String) onCategorySelected;

  const CategorySection({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const minGap = 12.0;
    const categories = ["All", "Design", "Programming", "UI/UX"];
    const estimatedTextWidth = 80.0;

    final totalNeededWidth =
        (estimatedTextWidth * categories.length) +
        (minGap * (categories.length - 1));
    final useWrap = totalNeededWidth > screenWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            "Courses",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 158, 154, 154),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Color.fromARGB(255, 86, 133, 220),
                Color.fromARGB(255, 29, 17, 91),
              ],
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
          },
          blendMode: BlendMode.srcIn,
          child:
              useWrap
                  ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children:
                          categories.map((label) {
                            return Padding(
                              padding: const EdgeInsets.only(right: minGap),
                              child: GestureDetector(
                                onTap: () => onCategorySelected(label),
                                child: CategoryText(
                                  label: label,
                                  isSelected: false,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        categories.map((label) {
                          return GestureDetector(
                            onTap: () => onCategorySelected(label),
                            child: CategoryText(
                              label: label,
                              isSelected: false,
                            ),
                          );
                        }).toList(),
                  ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

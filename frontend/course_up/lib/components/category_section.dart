import 'package:flutter/material.dart';
import 'package:course_up/components/category_text.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const minGap = 12.0;
    final categories = const ["All", "Design", "Programming", "UI/UX"];

    // Estimate total text width (rough average)
    const estimatedTextWidth = 80.0;
    final totalNeededWidth =
        (estimatedTextWidth * categories.length) +
        (minGap * (categories.length - 1));

    final useWrap = totalNeededWidth > screenWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Course",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
                    child: Row(
                      children:
                          categories
                              .map(
                                (label) => Padding(
                                  padding: const EdgeInsets.only(right: minGap),
                                  child: CategoryText(label: label),
                                ),
                              )
                              .toList(),
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        categories
                            .map((label) => CategoryText(label: label))
                            .toList(),
                  ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

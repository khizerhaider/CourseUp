import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:course_up/components/header.dart';
import 'package:course_up/components/cus_search_bar.dart';
import 'package:course_up/components/highlighted_course.dart';
import 'package:course_up/components/category_section.dart';
import 'package:course_up/components/course_grid.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF0F4FD),
        // gradient: LinearGradient(
        //   colors: [
        //     Color.fromARGB(255, 10, 6, 83),
        //     Color.fromARGB(255, 55, 42, 116),
        //   ],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          //HeaderSection(),
          const CusSearchBar(),
          const HighlightedCourse(),
          CategorySection(
            onCategorySelected: (String selected) {
              if (kDebugMode) {
                print("User selected: $selected");
              }
              // You can setState here if you're managing selection
            },
          ),
          const CourseList(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:course_up/components/course_card.dart';

class CourseList extends StatefulWidget {
  const CourseList({super.key});

  @override
  State<CourseList> createState() => _CourseListState();
}

class Course {
  final String title;
  final String thumbnail;

  Course({required this.title, required this.thumbnail});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(title: json['title'], thumbnail: json['thumbnail']);
  }
}

class _CourseListState extends State<CourseList> {
  late Future<List<Course>> _courses;

  @override
  void initState() {
    super.initState();
    _courses = fetchCourses();
  }

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/courses'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Course.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Course>>(
        future: _courses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No courses available.'));
          } else {
            final courses = snapshot.data!;
            return ListView.separated(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Delegate to parent scroll
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/courseDetails',
                      arguments: course.title,
                    );
                  },
                  child: CourseCard(
                    title: course.title,
                    thumbnailBase64: course.thumbnail,
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            );
          }
        },
      ),
    );
  }
}

// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
// import 'package:course_up/components/course_card.dart';

// class CourseGrid extends StatefulWidget {
//   const CourseGrid({super.key});

//   @override
//   State<CourseGrid> createState() => _CourseGridState();
// }

// class Course {
//   final String title;
//   final String thumbnail;

//   Course({required this.title, required this.thumbnail});

//   factory Course.fromJson(Map<String, dynamic> json) {
//     return Course(title: json['title'], thumbnail: json['thumbnail']);
//   }
// }

// class _CourseGridState extends State<CourseGrid> {
//   late Future<List<Course>> _courses;

//   @override
//   void initState() {
//     super.initState();
//     _courses = fetchCourses();
//   }

//   Future<List<Course>> fetchCourses() async {
//     final response = await http.get(
//       Uri.parse('http://localhost:5000/api/courses'),
//     );
//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map((json) => Course.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load courses');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: FutureBuilder<List<Course>>(
//           future: _courses,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('No courses available.'));
//             } else {
//               final courses = snapshot.data!;
//               return GridView.builder(
//                 // Add the return statement here
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                   maxCrossAxisExtent:
//                       280, // You can even reduce to 250 to avoid cramming
//                   mainAxisSpacing: 16,
//                   crossAxisSpacing: 16,
//                   childAspectRatio: 4 / 3,
//                 ),
//                 itemCount: courses.length,
//                 itemBuilder: (context, index) {
//                   final course = courses[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(
//                         context,
//                         '/courseDetails', // Navigate to the course details page
//                         arguments:
//                             course
//                                 .title, // Pass the course title as an argument
//                       );
//                     },
//                     child: CourseCard(
//                       title: course.title,
//                       thumbnailBase64: course.thumbnail,
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// // Function to launch the video URL
// void launchVideoUrl(String url) async {
//   if (await canLaunchUrl(url as Uri)) {
//     await launchUrl(url as Uri);
//   } else {
//     throw 'Could not launch $url';
//   }
// }

// // Function to decode base64 string to Uint8List
// Uint8List decodeBase64(String base64String) {
//   return base64.decode(base64String);
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class CourseGrid extends StatefulWidget {
  const CourseGrid({super.key});

  @override
  State<CourseGrid> createState() => _CourseGridState();
}

class Course {
  final String title;
  final String thumbnail;

  Course({required this.title, required this.thumbnail});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(title: json['title'], thumbnail: json['thumbnail']);
  }
}

class _CourseGridState extends State<CourseGrid> {
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
    return FutureBuilder<List<Course>>(
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
          return GridView.builder(
            // Add the return statement here
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 3 / 2,
            ),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/courseDetails', // Navigate to the course details page
                    arguments:
                        course.title, // Pass the course title as an argument
                  );
                },
                child: CourseCard(
                  title: course.title,
                  thumbnailBase64: course.thumbnail,
                ),
              );
            },
          );
        }
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String thumbnailBase64;

  const CourseCard({
    super.key,
    required this.title,
    required this.thumbnailBase64,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnailBytes = base64Decode(thumbnailBase64);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: const Offset(0, 4)),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.memory(
              thumbnailBytes,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Function to launch the video URL
void launchVideoUrl(String url) async {
  if (await canLaunchUrl(url as Uri)) {
    await launchUrl(url as Uri);
  } else {
    throw 'Could not launch $url';
  }
}
// Function to decode base64 string to Uint8List
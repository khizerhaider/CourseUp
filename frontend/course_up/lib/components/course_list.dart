import 'package:flutter/material.dart';
import 'package:course_up/services/api_service.dart';

class CourseList extends StatefulWidget {
  const CourseList({super.key});

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  late Future<List<dynamic>> _courses;

  @override
  void initState() {
    super.initState();
    _courses = ApiService.fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
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
          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return ListTile(
                title: Text(course['title']),
                subtitle: Text(course['description']),
                leading: Image.network(
                  'http://localhost:5000/${course['thumbnail']}',
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/courseDetails',
                    arguments: course['_id'],
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}

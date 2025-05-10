import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class CourseDetailPage extends StatelessWidget {
  final String slug;
  const CourseDetailPage({super.key, required this.slug});

  // Fetch course details by slug
  Future<Map<String, dynamic>> fetchCourseDetails() async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/courses/$slug'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load course details');
    }
  }

  // Fetch video titles for a course
  Future<List<String>> fetchCourseVideos() async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/courses/$slug/videos'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> videos = jsonDecode(response.body);
      return videos.map((video) => video['title'] as String).toList();
    } else {
      throw Exception('Failed to load course videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchCourseDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('Course not found.')));
        } else {
          final courseDetails = snapshot.data!;
          final Uint8List thumbnailBytes = base64Decode(
            courseDetails['thumbnail'],
          );

          return Scaffold(
            appBar: AppBar(title: Text(courseDetails['title'])),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.memory(thumbnailBytes),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(courseDetails['description']),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final videoTitles = await fetchCourseVideos();
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text('Videos'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          videoTitles
                                              .map((title) => Text('• $title'))
                                              .toList(),
                                    ),
                                  ),
                                ),
                          );
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $error')),
                          );
                        }
                      },
                      child: const Text('Start Course'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

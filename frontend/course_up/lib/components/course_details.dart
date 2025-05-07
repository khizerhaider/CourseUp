import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseDetails extends StatelessWidget {
  final String courseTitle;

  const CourseDetails({super.key, required this.courseTitle});

  Future<List<dynamic>> fetchVideos(String courseTitle) async {
    final response = await http.get(
      Uri.parse(
        'http://localhost:5000/api/courses/${Uri.encodeComponent(courseTitle)}',
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['videos']; // Assuming the backend sends videos in a "videos" field
    } else {
      throw Exception('Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(courseTitle)),
      body: FutureBuilder<List<dynamic>>(
        future: fetchVideos(courseTitle),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No videos available.'));
          } else {
            final videos = snapshot.data!;
            return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return ListTile(
                  title: Text(video['title']),
                  subtitle: Text(video['description']),
                  onTap: () {
                    // Handle video playback or navigation
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

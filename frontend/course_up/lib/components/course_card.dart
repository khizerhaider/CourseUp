import 'package:flutter/material.dart';
import 'dart:convert';

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
      padding: const EdgeInsets.all(10), // Slightly reduced padding
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, offset: Offset(0, 4), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reduced image height from 100 to 70
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              thumbnailBytes,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14, // Reduced font size slightly
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

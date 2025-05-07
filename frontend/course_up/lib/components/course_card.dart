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
